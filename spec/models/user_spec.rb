require 'rails_helper'

describe User do

  before do
    @user = User.new(first_name: 'Eigor', last_name: 'Gonzalez', email: 'eigor@editme.new', password: 'test123456')
    @empty_values = ['', ' ', nil]
    @invalid_emails = %w[test test.com @.com test@ test@com test@com]
  end

  it 'should respond to methods' do
    expect(@user).to respond_to :first_name
    expect(@user).to respond_to :last_name
    expect(@user).to respond_to :email
    expect(@user).to respond_to :password
    expect(@user).to respond_to :password_confirmation
    expect(@user).to respond_to :encrypted_password
    expect(@user).to respond_to :authenticate
  end

  def test_values_are_valid(base_user, attribute, values, valid)
    values.each do |val|
      test_user = base_user.dup
      test_user.send("#{attribute}=".to_sym, val)
      expect(test_user).send(valid ? :to : :to_not, be_valid)
    end
  end

  describe 'validate a users' do
    it 'that is valid' do
      expect(@user).to be_valid
    end

    it 'name is present' do
      names = %w[first_name last_name]
      names.each do |n|
       test_values_are_valid(@user,n, @empty_values, false)
      end
    end #must_match daver loves kater kind_of?

    it 'email is present and valid' do
      test_values_are_valid(@user,'email', (@invalid_emails + @empty_values), false)
    end
  end

  describe 'when email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email.upcase! # check uniqueness constraint is case insensitive
      user_with_same_email.save
    end

    it 'should not be valid' do
      expect(@user).to_not be_valid
    end
  end

  describe 'passwords and security' do
    before do
      @invalid_passwords = @empty_values + %w[1 1234567]
      @valid_passwords = %w[12345678 test12345 abcdefghi]
    end

    it 'passwords with more than 8 characters should be valid' do
      test_values_are_valid(@user, 'password', @valid_passwords, true)
    end

    it 'blank password should not be valid' do
      test_values_are_valid(@user, 'password', @invalid_passwords, false)
    end

    it 'should only be valid if password confirmation matches' do
      @valid_passwords.each do |pwd|
        test_user = @user.dup
        test_user.password = pwd
        test_user.password_confirmation = pwd
        expect(test_user).to be_valid

      end
    end

    it 'should be invalid if password confirmation does not match' do
      @valid_passwords.each do |pwd|
        test_user = @user.dup
        test_user.password = pwd

        test_user.password_confirmation = pwd + '1'
        expect(test_user).to_not be_valid

        test_user.password_confirmation = ''
        expect(test_user).to_not be_valid
      end
    end
  end
end
