require 'rspec'
require_relative '../../services/database'

# rubocop:disable Metrics/BlockLength
RSpec.describe Database::User do
  before(:each) do
    described_class.delete('test@example.com')
    described_class.delete('user@example.com')
    described_class.delete('admin@example.com')
  end

  describe '.create' do
    it 'creates a new user' do
      expect(described_class.create('test@example.com')).to be_truthy
    end

    it 'does not create a user if email already exists' do
      described_class.create('test@example.com')
      expect(described_class.create('test@example.com')).to be_falsey
    end
  end

  describe '.find_by_email' do
    it 'finds a user by email' do
      described_class.create('test@example.com')
      expect(described_class.find_by_email('test@example.com')).to be_truthy
    end

    it 'returns nil if user does not exist' do
      expect(described_class.find_by_email('nonexistent@example.com')).to be_nil
    end
  end

  describe '.exists?' do
    it 'returns true if user exists' do
      described_class.create('test@example.com')
      expect(described_class.exists?('test@example.com')).to be_truthy
    end

    it 'returns false if user does not exist' do
      expect(described_class.exists?('nonexistent@example.com')).to be_falsey
    end
  end

  describe '.delete' do
    it 'deletes a user' do
      described_class.create('test@example.com')
      expect(described_class.delete('test@example.com')).to be_truthy
      expect(described_class.exists?('test@example.com')).to be_falsey
    end
  end

  describe '.authenticate' do
    it 'authenticates a user with correct token' do
      token = described_class.create('test@example.com')
      described_class.activate!('test@example.com')
      expect(described_class.authenticate('test@example.com', token)).to be_truthy
    end

    it 'does not authenticate a user with incorrect token' do
      described_class.create('test@example.com')
      expect(described_class.authenticate('test@example.com', 'wrongtoken')).to be_falsey
    end

    it 'does not authenticate a user that does not exist' do
      expect(described_class.authenticate('nonexistent@example.com', 'anytoken')).to be_falsey
    end
  end

  describe '.admin?' do
    it 'returns true if user is an admin' do
      described_class.create('admin@example.com', 'admin')
      expect(described_class.admin?('admin@example.com')).to be_truthy
    end

    it 'returns false if user is not an admin' do
      described_class.create('user@example.com', 'user')
      expect(described_class.admin?('user@example.com')).to be_falsey
    end
  end

  describe '.user?' do
    it 'returns true if user is a user' do
      described_class.create('user@example.com', 'user')
      expect(described_class.user?('user@example.com')).to be_truthy
    end

    it 'returns false if user is not a user' do
      described_class.create('admin@example.com', 'admin')
      expect(described_class.user?('admin@example.com')).to be_falsey
    end
  end

  describe '.deletion' do
    it 'deletes custom users' do
      described_class.delete('admin@example.com')
      described_class.delete('user@example.com')
      described_class.delete('test@example.com')

      expect(described_class.exists?('admin@example.com')).to be_falsey
      expect(described_class.exists?('user@example.com')).to be_falsey
      expect(described_class.exists?('test@example.com')).to be_falsey
    end
  end
end
# rubocop:enable Metrics/BlockLength
