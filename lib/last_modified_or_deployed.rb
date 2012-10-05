module LastModifiedOrDeployed
  def last_modified(modified)
    super(modified > last_deployed ? modified : last_deployed)
  end

private

  def last_deployed
    Time.at ENV['RAILS_ASSET_ID'].to_i
  end
end
