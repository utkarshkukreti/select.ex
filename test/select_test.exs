defmodule SelectTest do
  use ExUnit.Case

  @html """
  <html>
    <head>
      <title>A Title</title>
    </head>
    <body>
      <h1>An H1</h1>
      <ul>
        <li>A List Item</li>
        <li>Another List Item</li>
      </ul>
      A Text Node
    </body>
  </html>
  """

  test "parse/1" do
    expected = {"html", [],
                [{"head", [], [{"title", [], ["A Title"]}]},
                 {"body", [],
                  [{"h1", [], ["An H1"]},
                   {"ul", [],
                    [{"li", [], ["A List Item"]},
                     {"li", [], ["Another List Item"]}]},
                   "\n    A Text Node\n  "]}]}

    assert Select.parse(@html) == expected
  end
end
