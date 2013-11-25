# == Schema Information
#
# Table name: survey_questions
#
#  id              :integer          not null, primary key
#  scale_min       :integer          default(1), not null
#  scale_max       :integer          default(5), not null
#  scaled          :boolean          default(FALSE), not null
#  targets_user    :boolean          default(FALSE), not null
#  allows_comments :boolean          default(FALSE), not null
#  human_string    :string(1024)     not null
#  scale_min_label :string(64)       default("Small"), not null
#  scale_max_label :string(64)       default("Large"), not null
#  created_at      :datetime
#  updated_at      :datetime
#

# A question in a survey.
class SurveyQuestion < ActiveRecord::Base
  # The user-visible question string.
  validates_length_of :human_string, in: 1..(1.kilobyte), allow_nil: false
  
  # True if the question asks for feedback on another user in the same team.
  #
  # If this is false, the question asks for feedback on the assignment.
  validates_inclusion_of :targets_user, in: [false, true],
                                        allow_nil: false

  # True if the question asks for comments, asides from the numerical answer.
  validates_inclusion_of :allows_comments, in: [false, true],
                                           allow_nil: false
  
  # True if the question's answer is an integer on a scale.
  #
  # If this is true, the question's answer UI will be a bunch of radio buttons.
  # Otherwise, the answer will be a text field.
  validates_inclusion_of :scaled, in: [false, true], allow_nil: false
  
  # The minimum value on the scale.
  validates_numericality_of :scale_min, only_integer: true,
                                        allow_nil: true
  # The maximum value on the scale.
  validates_numericality_of :scale_max, only_integer: true,
                                        allow_nil: true

  # User-visible label for the minimum value on the scale.
  validates_length_of :scale_min_label, in: 1..64, allow_nil: true
  # User-visible label for the maximum value on the scale.
  validates_numericality_of :scale_max, only_integer: true,
                                        allow_nil: true
end
