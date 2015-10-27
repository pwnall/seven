require 'test_helper'

class ProcAnalyzerTest < ActiveSupport::TestCase
  before do
    deliverable = assignments(:ps1).deliverables.build name: 'Moar answers',
        description: 'No no moar', file_ext: 'pdf'
    @analyzer = ProcAnalyzer.new deliverable: deliverable, auto_grading: false,
        message_name: 'analyze_pdf'
  end

  let(:analyzer) { analyzers(:proc_assessment_writeup) }
  let(:ok_pdf_submission) { submissions(:dexter_assessment) }
  let(:truncated_pdf_submission) { submissions(:deedee_assessment) }
  let(:py_submission) { submissions(:dexter_code) }

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

  it 'requires a proc method name' do
    @analyzer.message_name = nil
    assert @analyzer.invalid?
  end

  describe '#analyze_pdf' do
    it 'logs proper PDFs as :ok' do
      assert_equal true, ok_pdf_submission.db_file.f.exists?
      assert_equal :queued, ok_pdf_submission.analysis.status
      ProcAnalyzer.new.analyze_pdf ok_pdf_submission
      assert_equal :ok, ok_pdf_submission.analysis.status
    end

    it 'logs truncated PDFs as :wrong' do
      assert_equal true, truncated_pdf_submission.db_file.f.exists?
      assert_equal :queued, truncated_pdf_submission.analysis.status
      ProcAnalyzer.new.analyze_pdf truncated_pdf_submission
      assert_equal :wrong, truncated_pdf_submission.analysis.status
    end

    it 'logs non-PDFs as :wrong' do
      assert_equal true, py_submission.db_file.f.exists?
      assert_equal :queued, py_submission.analysis.status
      ProcAnalyzer.new.analyze_pdf py_submission
      assert_equal :wrong, py_submission.analysis.status
    end
  end

  describe '#zero_grades' do
    it 'assigns a grade of 0 to ungraded metrics for the given submission' do
      metrics = ok_pdf_submission.assignment.metrics
      set_grade, unset_grade = metrics.sort_by(&:name).map { |metric|
        metric.grades.where subject: users(:dexter)
      }

      assert_equal [80, nil],
          [set_grade.first.try(:score), unset_grade.first.try(:score)]

      ProcAnalyzer.new.zero_grades ok_pdf_submission

      assert_equal [80, 0],
          [set_grade.first.try(:score), unset_grade.first.try(:score)]
    end
  end
end
