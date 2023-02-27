defmodule CatalogPipelineTest do
  use ExUnit.Case
  doctest CatalogPipeline

  test "greets the world" do
    assert CatalogPipeline.hello() == :world
  end
end
