require 'json'
require 'zengin_code/version'
require 'zengin_code/bank'
require 'zengin_code/branch'

module ZenginCode
  class << self
    def preload!
      ZenginCode::Bank.all.values.each(&:branches)
    end
  end
end
