module Validation

  class InvalidError < TypeError; end
  class InvalidReadingError < InvalidError; end
  class InvalidWritingError < InvalidError; end
  class UnmanagebleError < InvalidError; end
  InvalidAdjustingError = UnmanagebleError

end