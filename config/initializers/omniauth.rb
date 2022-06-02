Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
           fields: %i[name email phone],
           on_failed_registration: lambda { |env| IdentitiesController.action(:new).call(env) }
  on_failure { |env| SessionsController.action(:failure).call(env) }
end
