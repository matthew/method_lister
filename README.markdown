About
=====

Method Lister is used to query objects and discover which ancestor implements
which methods. It's quite common to have a lot of mixins and several classes
in an object's class hierarchy, especially in a Rails application. To help
with this Method Lister adds the ability to find out in which classes/modules
the methods on an object are implemented.

Method Lister adds 3 methods to all objects in the system: `ls`, `grep`, and
`which`. Since these names are sometimes taken you can also use `mls`,
`mgrep`, and `mwhich`.  

Method Lister is intended to be used from IRB or during debugging.

Install
=======

Get the gem:

    # Add GitHub as a Gem Source (only have to do this once)
    gem sources -a http://gems.github.com
    
    # Install the gem
    sudo gem install matthew-method_lister
    
    # Otherwise, build the gem and install it
    rake gem
    sudo gem install pkg/*.gem

Open up `~/.irbrc` and add these lines:

    require 'rubygems'
    require 'method_lister'
    
Usage
=====

`ls` or `mls`
-------------

The `ls` command will list all methods an object responds to, organized by the
module or class which provides the implementation. For example (results may
vary, depending on what you have loaded):

    >> [].ls
    ========== Module Kernel ==========
    PUBLIC: == === =~ __id__ __send__ class clone display dup eql? equal?
    extend freeze frozen? gem grep hash id inspect instance_eval instance_of?
    instance_variable_defined? instance_variable_get instance_variable_set
    instance_variables is_a? kind_of? ls method methods mgrep mls mwhich nil?
    object_id pretty_inspect private_methods protected_methods public_methods
    require respond_to? send singleton_methods taint tainted? to_a to_s type
    untaint which

    PRIVATE: Array Float Integer String URI ` abort at_exit autoload autoload?
    binding block_given? callcc caller catch chomp chomp! chop chop! eval exec
    exit exit! fail fork format gem_original_require getc gets
    global_variables gsub gsub! initialize_copy iterator? lambda load
    local_variables loop method_missing open p pp print printf proc putc puts
    raise rand readline readlines remove_instance_variable scan select
    set_trace_func singleton_method_added singleton_method_removed
    singleton_method_undefined sleep split sprintf srand sub sub! syscall
    system test throw trace_var trap untrace_var warn

    ========== Module PP::ObjectMixin ==========
    PUBLIC: pretty_print pretty_print_cycle pretty_print_inspect
    pretty_print_instance_variables

    ========== Class Object ==========
    PRIVATE: initialize irb_binding timeout

    ========== Module Enumerable ==========
    PUBLIC: all? any? collect detect each_with_index entries find find_all
    grep include? inject map max member? min partition reject select sort
    sort_by to_a zip

    ========== Class Array ==========
    PUBLIC: & * + - << <=> == [] []= assoc at clear collect collect! compact
    compact! concat delete delete_at delete_if each each_index empty? eql?
    fetch fill first flatten flatten! frozen? hash include? index indexes
    indices insert inspect join last length map map! nitems pack pop
    pretty_print pretty_print_cycle push rassoc reject reject! replace reverse
    reverse! reverse_each rindex select shift size slice slice! sort sort!
    to_a to_ary to_s transpose uniq uniq! unshift values_at zip |

    PRIVATE: initialize initialize_copy

You can show only the public methods by passing in "true":

    >> [].ls true
    ========== Module Kernel ==========
    PUBLIC: == === =~ __id__ __send__ class clone display dup eql? equal?
    extend freeze frozen? gem grep hash id inspect instance_eval instance_of?
    instance_variable_defined? instance_variable_get instance_variable_set
    instance_variables is_a? kind_of? ls method methods mgrep mls mwhich nil?
    object_id pretty_inspect private_methods protected_methods public_methods
    require respond_to? send singleton_methods taint tainted? to_a to_s type
    untaint which

    ========== Module PP::ObjectMixin ==========
    PUBLIC: pretty_print pretty_print_cycle pretty_print_inspect
    pretty_print_instance_variables

    ========== Module Enumerable ==========
    PUBLIC: all? any? collect detect each_with_index entries find find_all
    grep include? inject map max member? min partition reject select sort
    sort_by to_a zip

    ========== Class Array ==========
    PUBLIC: & * + - << <=> == [] []= assoc at clear collect collect! compact
    compact! concat delete delete_at delete_if each each_index empty? eql?
    fetch fill first flatten flatten! frozen? hash include? index indexes
    indices insert inspect join last length map map! nitems pack pop
    pretty_print pretty_print_cycle push rassoc reject reject! replace reverse
    reverse! reverse_each rindex select shift size slice slice! sort sort!
    to_a to_ary to_s transpose uniq uniq! unshift values_at zip |

`grep` or `mgrep`
-----------------

The `grep` command takes a regular expression and only returns methods which
match the given regex. In this example we'll use `mgrep` since on Array
objects `grep` is already taken:

    >> [].mgrep /f/
    ========== Module Kernel ==========
    PUBLIC: freeze frozen? instance_of? instance_variable_defined? kind_of?

    PRIVATE: fail fork format method_missing printf set_trace_func
    singleton_method_undefined sprintf

    ========== Module Enumerable ==========
    PUBLIC: find find_all

    ========== Class Array ==========
    PUBLIC: delete_if fetch fill first flatten flatten! frozen? shift unshift

Similar to `ls` you can pass in an extra argument of "true" to see only the
public methods:

    >> [].mgrep /f/, true
    ========== Module Kernel ==========
    PUBLIC: freeze frozen? instance_of? instance_variable_defined? kind_of?

    ========== Module Enumerable ==========
    PUBLIC: find find_all

    ========== Class Array ==========
    PUBLIC: delete_if fetch fill first flatten flatten! frozen? shift unshift

Note that `method_missing` is always considered a match, since it could always
potentially execute.

`which` or `mwhich`
-------------------

The `which` command is for finding which classes or modules implement the
method you're seeking. You can pass the method name in as a string or symbol.

    >> [].which :to_a
    ========== Module Kernel ==========
    PUBLIC: to_a

    ========== Module Enumerable ==========
    PUBLIC: to_a

    ========== Class Array ==========
    PUBLIC: to_a

Logically the `which` command is the same as `grep(/^your_method$/)` and so
the same comments apply about `method_missing` and the optional parameter to
see only public methods.

Known Bugs
==========

If a singleton method overrides some method from an ancestor then the method
will be reported on the ancestor only and not both the ancestor and the
eigenclass. For example:

    >> class Foo; def doit; end; end
    => nil

    >> f = Foo.new
    => #<Foo:0x3395a0>

    >> class << f; def doit; end; end
    => nil

    >> f.mgrep /doit/
    ========== Module Kernel ==========
    PRIVATE: method_missing

    ========== Class Foo ==========
    PUBLIC: doit
  
This was done on purpose to support listing singleton methods on cloned
objects. I couldn't support both features since the reflection methods for
eigenclasses are buggy.

License
=======

Copyright 2008, 2009, Matthew O'Connor All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Ruby 1.8.7 itself.