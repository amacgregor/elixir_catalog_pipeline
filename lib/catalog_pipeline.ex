defmodule CatalogPipeline do
  use Flow

  def get_products do
    product = extract_product_data('https://dummyjson.com/products')
    |> transform_product_data()
    |> validate_product_data()
    |> load_product_data()
    |> IO.inspect()

  end

  defp extract_product_data(url) do
    extracted_data =
      HTTPoison.get!(url)
      |> Map.get(:body)
      |> Poison.decode!()
      |> Map.get("products")
      |> Flow.from_enumerable()
  end

  defp transform_product_data(extracted_data) do
    transformed_data = extracted_data
      |> Flow.map(fn product -> {product["description"], product["title"], product["price"]} end)
  end

  defp validate_product_data(transformed_data) do
    validated_data =
      transformed_data
      |> Flow.filter(fn {description, title, price} -> description != "" and price != "" end)
  end

  defp load_product_data(validated_data) do
    product_list = validated_data
    |> Flow.map(fn {description, title, price} -> %{title: title, price: price, description: description} end)
    |> Enum.to_list()
  end
end
