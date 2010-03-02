Given /^I create an account for user (\w+) with (\d+) €$/ do |name, opening_balance|
  user = User.create!(:name => name)
  user.create_account(:opening_balance => opening_balance)
end

Then /^an account for user (\w+) exists$/ do |name|
  @account = User.find_by_name(name).account
  assert_not_nil @account
end

Then /^the account has (a|\d+) journals?$/ do |num_journals|
  if ['a', '1'].include? num_journals
    @journal = @account.journals.first
  else
    @journals = @account.journals
  end
  assert_equal num_journals.to_i, @account.journals.count
end

Then /^the journal has (\d+) postings? with (\d+) €$/ do |num_postings, amount|
  @postings = @journal.postings
  assert_equal num_postings.to_i, @postings.size
  @postings.each do |posting|
    assert_equal amount.to_i, posting.amount
  end
end

Then /^(\w+)'?s? account balance is (\d+) €$/ do |name, balance|
  account = (name == 'the' ? @account : User.find_by_name(name).account)
  assert_equal balance.to_i, account.balance
end

When /^I transfer (\d+) € from (\w+)'s account to (\w+)'s account$/ do |amount, from, to|
  from_account = User.find_by_name(from).account
  to_account = User.find_by_name(to).account
  from_account.transfer(amount.to_i, to_account)
end