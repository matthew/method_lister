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

Build the gem:
    
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
    PUBLIC: inspect clone method public_methods instance_variable_defined?
    equal? which freeze grep mgrep methods respond_to? dup instance_variables
    __id__ object_id eql? require id singleton_methods send taint frozen?
    instance_variable_get __send__ instance_of? mls to_a type mwhich
    protected_methods instance_eval == display === ls instance_variable_set
    kind_of? extend to_s gem hash pretty_inspect class tainted? =~
    private_methods nil? untaint is_a?

    ========== Module PP::ObjectMixin ==========
    PUBLIC: pretty_print_instance_variables pretty_print_inspect pretty_print
    pretty_print_cycle

    ========== Module Enumerable ==========
    PUBLIC: find_all sort_by collect include? detect max sort partition any?
    to_a reject zip find min member? entries inject all? select
    each_with_index grep map

    ========== Class Array ==========
    PUBLIC: delete_if & map! empty? indexes rindex reject last to_s assoc
    reverse! sort each include? values_at slice * sort! each_index fetch +
    clear pretty_print concat size join flatten! shift - eql? reverse to_ary
    insert [] indices nitems inspect rassoc replace compact! []= | collect
    push delete_at << frozen? reverse_each flatten hash collect! uniq! select
    first to_a fill index reject! zip pack unshift compact transpose <=>
    pretty_print_cycle at == slice! length uniq delete pop map

You can show protected and private methods too by passing in "true":

    >> [].ls true
    ========== Module Kernel ==========
    PUBLIC: inspect clone method public_methods instance_variable_defined?
    equal? which freeze grep mgrep methods respond_to? dup instance_variables
    __id__ object_id eql? require id singleton_methods send taint frozen?
    instance_variable_get __send__ instance_of? mls to_a type mwhich
    protected_methods instance_eval == display === ls instance_variable_set
    kind_of? extend to_s gem hash pretty_inspect class tainted? =~
    private_methods nil? untaint is_a?

    PRIVATE: select global_variables readline warn singleton_method_added gsub
    exit! method_missing exec abort load chomp! remove_instance_variable print
    eval proc untrace_var srand Integer local_variables
    singleton_method_removed readlines raise chop getc gem_original_require
    system at_exit putc set_trace_func rand test lambda Float p
    initialize_copy singleton_method_undefined chomp fail callcc sub! syscall
    sleep iterator? catch autoload puts ` pp String sprintf split caller gsub!
    open block_given? throw URI gets trap sub loop Array fork format exit
    chop! printf binding autoload? scan trace_var

    ========== Module PP::ObjectMixin ==========
    PUBLIC: pretty_print_instance_variables pretty_print_inspect pretty_print
    pretty_print_cycle

    ========== Class Object ==========
    PRIVATE: initialize  timeout  irb_binding

    ========== Module Enumerable ==========
    PUBLIC: find_all sort_by collect include? detect max sort partition any?
    to_a reject zip find min member? entries inject all? select
    each_with_index grep map

    ========== Class Array ==========
    PUBLIC: delete_if & map! empty? indexes rindex reject last to_s assoc
    reverse! sort each include? values_at slice * sort! each_index fetch +
    clear pretty_print concat size join flatten! shift - eql? reverse to_ary
    insert [] indices nitems inspect rassoc replace compact! []= | collect
    push delete_at << frozen? reverse_each flatten hash collect! uniq! select
    first to_a fill index reject! zip pack unshift compact transpose <=>
    pretty_print_cycle at == slice! length uniq delete pop map

    PRIVATE: initialize_copy initialize
    
`grep` or `mgrep`
-----------------

The `grep` command takes a regular expression and only returns methods which
match the given regex. In this example we'll use `mgrep` since on Array
objects `grep` is already taken:

    >> [].mgrep /f/
    ========== Module Kernel ==========
    PUBLIC: instance_variable_defined? freeze frozen? instance_of? kind_of?

    ========== Module Enumerable ==========
    PUBLIC: find_all  find

    ========== Class Array ==========
    PUBLIC: delete_if fetch flatten! shift frozen? flatten first fill unshift

Similar to `ls` you can pass in an extra argument of "true" to see protected
and private methods:

    >> [].mgrep /f/, true
    ========== Module Kernel ==========
    PUBLIC: instance_variable_defined? freeze frozen? instance_of? kind_of?

    PRIVATE: method_missing set_trace_func singleton_method_undefined fail
    sprintf fork format printf

    ========== Module Enumerable ==========
    PUBLIC: find_all find

    ========== Class Array ==========
    PUBLIC: delete_if fetch flatten! shift frozen? flatten first fill unshift
    
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
see protected/private methods.

License
=======

Copyright 2008, Matthew O'Connor All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Ruby 1.8.7 itself.
