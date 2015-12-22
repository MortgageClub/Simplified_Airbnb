require 'rails_helper'
require 'spec_helper'

describe Photo do
  it { should belong_to(:room) }
end
