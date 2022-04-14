Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
           fields: %i[name email phone],
           on_failed_registration: IdentitiesController.action(:new),
           on_failure: SessionsController.action(:failure)
end
