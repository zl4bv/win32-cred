require 'spec_helper'

describe Win32::Cred::Credential do
  describe '.enumerate' do
    it 'enumerates the credentials from the user"s credential set'
  end

  describe '.read' do
    it 'reads a credential from the user"s credential set'
  end

  describe '.write' do
    it 'creates a new credential or modifies an existing credential in the user"s credential set'
  end

  describe '#comment' do
    it 'returns a string comment from the user that describes the credential'
  end

  describe '#credential_blob' do
    it 'returns secret data for the credential'
  end

  describe '#flags' do
    it 'returns a list of flags that identify characteristics of the credential'
  end

  describe '#last_written' do
    it 'returns the time of the last modification of the credential'
  end

  describe '#persist' do
    it 'defines the persistence of the credential'
  end

  describe '#prompt_now?' do
    it 'returns true if the flag is set'
  end

  describe '#target_alias' do
    it 'returns an alias for the target_name member'
  end

  describe '#target_name' do
    it 'returns the name of the credential'
  end

  describe '#to_credential_struct' do
    it 'returns a CREDENTIAL struct'    
  end

  describe '#type' do
    it 'returns the type of the credential'
  end

  describe '#user_name' do
    it 'returns the user name of the account used to connect to target_name'
  end

  describe '#username_target?' do
    it 'returns true if the flag is set'
  end
end
