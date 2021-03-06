# coding: us-ascii
# frozen_string_literal: true

module Validation
  class InvalidError < TypeError; end
  class InvalidReadingError < InvalidError; end
  class InvalidWritingError < InvalidError; end
  class InvalidAdjustingError < InvalidError; end
end
