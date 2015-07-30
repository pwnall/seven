require 'test_helper'

class ScriptAnalyzerTest < ActiveSupport::TestCase
  before do
    @analyzer = ScriptAnalyzer.new deliverable: deliverables(:project_writeup),
        auto_grading: false, db_file: db_files(:ps1_script_analyzer),
        time_limit: 2, ram_limit: 1024, file_limit: 10, file_size_limit: 100,
        process_limit: 5
  end

  let(:analyzer) { analyzers(:script_assessment_code) }

  it 'validates the setup analyzer' do
    assert @analyzer.valid?, @analyzer.errors.full_messages
  end

  describe 'core analyzer functionality' do
    it 'requires a deliverable' do
      @analyzer.deliverable = nil
      assert @analyzer.invalid?
    end

    it 'forbids a deliverable from having multiple analyzers' do
      @analyzer.deliverable = analyzer.deliverable
      assert @analyzer.invalid?
    end

    it 'must state whether grades are automatically updated' do
      @analyzer.auto_grading = nil
      assert @analyzer.invalid?
    end
  end

  describe 'database-backed file association' do
    it 'requires a database-backed file with the analyzer script' do
      @analyzer.db_file = nil
      assert @analyzer.invalid?
    end

    it 'destroys dependent records' do
      assert_not_nil analyzer.db_file

      analyzer.destroy

      assert_nil DbFile.find_by(id: analyzer.db_file_id)
    end

    it 'validates associated database-backed files' do
      db_file = @analyzer.build_db_file
      assert_equal false, db_file.valid?
      assert_equal false, @analyzer.valid?
    end

    it 'saves associated database-backed files through the parent analyzer' do
      assert_equal true, @analyzer.new_record?
      @analyzer.save!
      assert_not_nil @analyzer.reload.db_file
    end

    it 'rejects database file associations with a blank attachment' do
      assert_equal 'fib_grading.zip', analyzer.db_file.f_file_name
      analyzer.update! db_file_attributes: { f: '' }
      assert_equal 'fib_grading.zip', analyzer.reload.db_file.f_file_name
    end

    it 'destroys the database file when it is replaced' do
      assert_not_nil analyzer.db_file
      former_db_file_id = analyzer.db_file.id
      new_db_file = fixture_file_upload 'analyzer_files/fib.zip',
          'application/zip', :binary
      analyzer.update! db_file_attributes: { f: new_db_file }
      assert_nil DbFile.find_by(id: former_db_file_id)
    end

    describe '#file_name' do
      it 'returns the name of the uploaded file' do
        assert_equal 'fib_grading.zip', analyzer.file_name
      end

      it 'returns nil if no file has been uploaded' do
        analyzer.db_file = nil
        assert_nil analyzer.file_name
      end
    end

    describe '#contents' do
      it 'returns the contents of the uploaded file' do
        path = File.join ActiveSupport::TestCase.fixture_path, 'analyzer_files',
            'fib_grading.zip'
        assert_equal File.binread(path), analyzer.contents
      end

      it 'returns nil if no file has been uploaded' do
        analyzer.db_file = nil
        assert_nil analyzer.contents
      end
    end
  end
end
