# Development

To create a new courier service client:

1. Create a folder in the name of your module in `lib/sharktrack/`.
2. Implement a client that extends `Sharktrack::HTTPClient`.
3. Use `define_service` in `sharktrack.rb`
4. Access methods like `Sharktrack::CourierName.tracking_number(*args)`
