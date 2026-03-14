Rails.application.routes.draw do
  # Homepage -> new moodboard form
  get("/", { :controller => "moodboards", :action => "new" })

  # Form submit
  post("/moodboards", { :controller => "moodboards", :action => "create" })

  # Show a single moodboard
  get("/moodboards/:id", { :controller => "moodboards", :action => "show" })
end
