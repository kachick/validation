module Validation

  class InvalidError < TypeError; end
  class InvalidReadingError < InvalidError; end
  class InvalidWritingError < InvalidError; end
  class InvalidAdjustingError < InvalidError; end
  UnmanagebleError = InvalidAdjustingError

end