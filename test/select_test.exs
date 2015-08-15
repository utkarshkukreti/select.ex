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

  test "matches?(_, {:attr, _, _})" do
    node = {"foo", [{"bar", ""}, {"baz", "quux"}], []}
    assert Select.matches?(node, {:attr, "bar", ""})
    assert !Select.matches?(node, {:attr, "bar", "."})
    assert Select.matches?(node, {:attr, "baz", "quux"})
    assert !Select.matches?(node, {:attr, "baz", "."})
    assert !Select.matches?(node, {:attr, "quux"})
    assert !Select.matches?("bar", {:attr, "bar"})
  end

  test "matches?(_, {:and, _, _})" do
    node = {"foo", [{"bar", ""}, {"baz", "quux"}], []}
    assert Select.matches?(node, {:and, {:name, "foo"}, {:attr, "baz"}})
    assert Select.matches?(node, {:and, {:attr, "bar"}, {:attr, "baz"}})
    assert !Select.matches?(node, {:and, {:attr, "bar"}, {:attr, "quux"}})
    assert !Select.matches?("foo", {:and, {:name, "foo"}, {:attr, "baz"}})
  end

  test "matches?(_, {:or, _, _})" do
    node = {"foo", [{"bar", ""}, {"baz", "quux"}], []}
    assert Select.matches?(node, {:or, {:name, "foo"}, {:attr, "baz"}})
    assert Select.matches?(node, {:or, {:attr, "bar"}, {:attr, "baz"}})
    assert !Select.matches?(node, {:or, {:name, "bar"}, {:attr, "quux"}})
    assert !Select.matches?("foo", {:or, {:name, "foo"}, {:attr, "baz"}})
  end

  test "matches?(_, {:not, _})" do
    node = {"foo", [{"bar", ""}, {"baz", "quux"}], []}
    assert !Select.matches?(node, {:not, {:name, "foo"}})
    assert Select.matches?(node, {:not, {:name, "bar"}})
    assert Select.matches?("foo", {:not, {:name, "foo"}})
  end

  test "matches?(_, {:class, _})" do
    node = {"foo", [{"class", "bar baz"}], []}
    assert Select.matches?(node, {:class, "bar"})
    assert Select.matches?(node, {:class, "baz"})
    assert !Select.matches?(node, {:class, "quux"})
    assert !Select.matches?({"foo", [], []}, {:class, "foo"})
    assert !Select.matches?("foo", {:class, "foo"})
  end

  test "matches?(_, :element)" do
    assert Select.matches?({"foo", [], []}, :element)
    assert !Select.matches?("foo", :element)
  end

  test "matches?(_, :text)" do
    assert !Select.matches?({"foo", [], []}, :text)
    assert Select.matches?("foo", :text)
  end

  test "find/2" do
    node = Select.parse(@html)
    assert 2 = Select.find(node, {:name, "li"}) |> Enum.count
    assert 8 = Select.find(node, :element) |> Enum.count
    assert 5 = Select.find(node, :text) |> Enum.count
  end
end
