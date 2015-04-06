class Boolean
  `def._isBoolean = true`

  class << self
    undef_method :new
  end

  def !
    `self != true`
  end

  def &(other)
    `(self == true) ? (other !== false && other !== nil) : false`
  end

  def |(other)
    `(self == true) ? true : (other !== false && other !== nil)`
  end

  def ^(other)
    `(self == true) ? (other === false || other === nil) : (other !== false && other !== nil)`
  end

  def ==(other)
    `(self == true) === other.valueOf()`
  end

  alias equal? ==

  alias singleton_class class

  def to_s
    `(self == true) ? 'true' : 'false'`
  end
end

TrueClass  = Boolean
FalseClass = Boolean

TRUE  = true
FALSE = false
