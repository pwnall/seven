# == Schema Information
#
# Table name: analyzers
#
#  id             :integer(4)      not null, primary key
#  deliverable_id :integer(4)      not null
#  type           :string(32)      not null
#  input_file     :string(64)
#  exec_limits    :text
#  db_file_id     :integer(4)
#  message_name   :string(64)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

# Submission checker that runs an external script.
class ScriptAnalyzer < Analyzer
  # Name to be used when saving the submission into the script directory.
  validates :input_file, :length => 1..256, :presence => true
  attr_accessible :input_file
    
  # The database-backed file holding the analyzer script.
  belongs_to :db_file, :dependent => :destroy
  validates :db_file, :presence => true
  accepts_nested_attributes_for :db_file
  attr_accessible :db_file_attributes
  
  # Database-backed file association, including the file contents.
  def full_db_file
    DbFile.unscoped.where(:id => db_file_id).first
  end
  
  # Limits that apply when running the analyzer script.
  store :exec_limits
  
  # Maximum number of seconds of CPU time that the analyzer can use.
  validates :time_limit, :presence => true,
      :numericality => { :only_integer => true, :greater_than => 0 }
  store_accessor :exec_limits, :time_limit
  attr_accessible :time_limit

  # Maximum number of megabytes of RAM that the analyzer can use.
  validates :ram_limit, :presence => true,
      :numericality => { :only_integer => true, :greater_than => 0 }
  store_accessor :exec_limits, :ram_limit
  attr_accessible :ram_limit
    
  # Maximum number of file descriptors that the analyzer can use.
  validates :file_limit, :presence => true,
      :numericality => { :only_integer => true, :greater_than => 0 }
  store_accessor :exec_limits, :file_limit
  attr_accessible :file_limit

  # Maximum number of megabytes that the analyzer can write to a single file.
  validates :file_size_limit, :presence => true,
      :numericality => { :only_integer => true, :greater_than => 0 }
  store_accessor :exec_limits, :file_size_limit
  attr_accessible :file_size_limit
  
  # Maximum number of processes that the analyzer can use.
  validates :process_limit, :presence => true,
      :numericality => { :only_integer => true, :greater_than => 0 }
  store_accessor :exec_limits, :process_limit
  attr_accessible :process_limit

  # :nodoc: overrides Analyzer#analyze
  def analyze(submission)
    Dir.mktmpdir 'seven_' do |temp_dir|
      Dir.chdir temp_dir do
        unpack_script
        write_submission submission
        result_hash = run_script
        score_submission submission, result_hash
      end
    end
  end
  
  # Copies the checker script data into the current directory.
  #
  # This should be run in a temporary directory.
  def unpack_script
    package_file = Tempfile.new 'seven_package_'
    package_file.close
    File.open package_file.path, 'wb' do |f|
      f.write full_db_file.f.file_contents
    end
    
    Zip::ZipFile.open package_file.path do |zip_file|
      zip_file.each do |f|
        next if f.name.index '..'
        f_dir = File.dirname f.name
        FileUtils.mkdir_p f_dir unless f_dir.empty?
        zip_file.extract f, f.name unless File.exist?(f.name)
      end
    end
    package_file.unlink
    
    File.chmod 0700, 'run' if File.exist?('run')
  end
  
  # Copies a submission into the current directory.
  #
  # This should be run in a temporary directory.
  def write_submission(submission)
    File.open input_file, 'wb' do |f|
      f.write submission.full_db_file.f.file_contents
    end
  end
  
  # Runs the checker's script, assuming it is in the current directory.
  def run_script
    connection = ActiveRecord::Base.remove_connection
    begin
      case RUBY_PLATFORM
      when /darwin/ 
        command = ['nice', '-n', '20', './run']
      when /linux/
        command = ['nice', '--adjustment=20', './run']
      else
        command = ['nice', './run']
      end
      File.open('.log', 'w') { |f| f.write '' }
      io = { :in => '/dev/null', :out => '.log', :err => STDOUT }
      limits = { :cpu => time_limit.to_i + 1,
            :file_size => file_size_limit.to_i.megabytes,
            :open_files => 10 + file_limit.to_i,
            :data => ram_limit.to_i.megabytes
          }
      
      pid = ExecSandbox::Spawn.spawn command, io, {}, limits
           
      status = ExecSandbox::Wait4.wait4 pid
      log = File.exist?('.log') ? File.read('.log') : 'Program removed its log'
      
      { :log => log, :status => status }
    ensure
      ActiveRecord::Base.establish_connection connection || {}
    end
  end

  # Computes the score for the submission and saves it into the analysis.  
  def score_submission(submission, result)
    log = result[:log]
    
    running_time = result[:status][:system_time] + result[:status][:user_time]
    if running_time > time_limit.to_i
      status = :limit_exceeded
      status_log = <<END_LOG
Your submission exceeded the time limit of #{time_limit.to_i} seconds.
The process was terminated after running for #{running_time} seconds.
END_LOG
      score = 0
    elsif result[:status][:exit_code] != 0
      status = :crashed
      status_log = <<END_LOG
Your submission crashed with exit code #{result[:status][:exit_code]}.
The process ran for #{running_time} seconds.
END_LOG
      score = 0
    else
      begin
        log_diags = log.slice(0, log.index(/[\n\r]{2}/m)).split(/[\n\r]+/m)
        tests = log_diags.length
        passed = log_diags.select { |d| !(d =~ /FAIL/ || d =~ /ERROR/) }.length
        
        status = (passed == tests) ? :ok : :wrong
        status_log = <<END_LOG
Your submission passed #{passed} tests out of #{tests}.
The process ran for #{running_time} seconds.
END_LOG
        score = (100 * passed / tests.to_f).round
      rescue
        status = :ok
        status_log = <<END_LOG
The analyzer ran successfully, but did not report a score for your submission.
The process ran for #{running_time} seconds.
END_LOG
        score = 100
      end
    end
    
    analyis = submission.analysis
    analyis.log = [log, status_log].join("\n")
    analyis.status = status
    analyis.score = score
    analyis.save!
  end
end
