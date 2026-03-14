Rails.application.routes.draw do
  devise_for(:users)

  # Home: upload form (requires login)
  get("/", { :controller => "inspirations", :action => "new" })

  # Past searches for current user
  get("/inspirations", { :controller => "inspirations", :action => "index" })

  get("/inspirations/new", { :controller => "inspirations", :action => "new" })
  post("/inspirations", { :controller => "inspirations", :action => "create" })
  get("/inspirations/:id", { :controller => "inspirations", :action => "show" })
end
