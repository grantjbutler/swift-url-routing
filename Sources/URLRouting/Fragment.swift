/// Parses a request's fragment.
public struct Fragment<Parsers: Parser>: Parser
where Parsers.Input == Substring {
  @usableFromInline
  let parsers: Parsers

  @inlinable
  public init(@ParserBuilder build: () -> Parsers) {
    self.parsers = build()
  }

  @inlinable
  public func parse(_ data: inout URLRequestData) throws -> Parsers.Output {
    guard let fragment = data.fragment else { throw RoutingError() }
    var input = fragment[...]
    let output = try self.parsers.parse(&input)
    return output
  }
}

extension Fragment: ParserPrinter where Parsers: ParserPrinter {
  @inlinable
  public func print(_ output: Parsers.Output, into input: inout URLRequestData) rethrows {
    var fragment = (input.fragment ?? "")[...]
    try self.parsers.print(output, into: &fragment)
    input.fragment = String(fragment)
  }
}
