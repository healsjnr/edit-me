# TODO Extract to Env Vars.
# These creds are locked down and rotated regularly
FOG_CONNECTION = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_secret_access_key    => 'GXgMq15c/IlqvNT74OuXU84HFTxo+Wn9hTje52hv',
  :aws_access_key_id        => 'AKIAJJBEPPWAAI4RGSXA',
  :region                   => 'ap-southeast-2'})