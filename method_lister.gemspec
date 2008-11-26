GemSpec = Gem::Specification.new do |s|
    s.platform  =   Gem::Platform::RUBY
    s.name      =   "method_lister"
    s.version   =   "0.2.3"
    s.author    =   "Matthew O'Connor"
    s.email     =   "matthew @nospam@ canonical.org"
    s.homepage  =   "http://github.com/matthew/method_lister/tree/master"
    s.rubyforge_project = "method_lister"
    s.summary   =   "Pretty method listers and finders, for use in IRB."
    s.files     =   [
     "lib/method_lister/color_display.rb",
     "lib/method_lister/find_result.rb",
     "lib/method_lister/finder.rb",
     "lib/method_lister/ruby_ext.rb",
     "lib/method_lister/simple_display.rb",
     "lib/method_lister.rb",
     "spec/color_display_spec.rb",
     "spec/find_result_spec.rb",
     "spec/finder_spec.rb",
     "spec/helpers/matchers/list_methods.rb",
     "spec/helpers/object_mother/find_result.rb",
     "spec/helpers/object_mother/find_scenario.rb",
     "spec/rcov.opts",
     "spec/ruby_ext_spec.rb",
     "spec/scenarios/class_with_inheritance.rb",
     "spec/scenarios/class_with_inheritance_and_modules.rb",
     "spec/scenarios/eigenclass.rb",
     "spec/scenarios/eigenclass_with_modules.rb",
     "spec/scenarios/filters_results_without_methods.rb",
     "spec/scenarios/mixed_visibility_methods.rb",
     "spec/scenarios/object_without_eigenclass.rb",
     "spec/scenarios/overloaded_methods.rb",
     "spec/scenarios/overloaded_methods_with_modules_mixed_in.rb",
     "spec/scenarios/private_methods.rb",
     "spec/scenarios/single_class.rb",
     "spec/scenarios/single_class_with_module_mixed_in.rb",
     "spec/simple_display_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"]
    s.require_path  =   "lib"
    s.test_files    = [
       "spec/color_display_spec.rb",
       "spec/find_result_spec.rb",
       "spec/finder_spec.rb",
       "spec/ruby_ext_spec.rb",
       "spec/simple_display_spec.rb"]
    s.has_rdoc      =  true
    s.extra_rdoc_files = ["README.markdown"]
end
