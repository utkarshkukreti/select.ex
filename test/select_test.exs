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

  test "matches?(_, fn)" do
    assert Select.matches?("foo", fn x -> x == "foo" end)
    assert !Select.matches?("foo", fn x -> x == "bar" end)
  end

  test "matches?(_, {:name, _})" do
    assert Select.matches?({"foo", [], []}, {:name, "foo"})
    assert !Select.matches?({"foo", [], []}, {:name, "bar"})
    assert !Select.matches?("foo", {:name, "foo"})
  end

  test "matches?(_, {:attr, _})" do
    node = {"foo", [{"bar", ""}, {"baz", "quux"}], []}
    assert Select.matches?(node, {:attr, "bar"})
    assert Select.matches?(node, {:attr, "baz"})
    assert !Select.matches?(node, {:attr, "quux"})
    assert !Select.matches?("bar", {:attr, "bar"})
  end
end
