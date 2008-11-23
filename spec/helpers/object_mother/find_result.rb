def result(object, options)
  MethodLister::FindResult.new(options.merge(:object => object))
end