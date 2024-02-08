# NetworkKit Documentation

## Overview
NetworkKit is a Swift package designed to simplify networking tasks within your iOS or Swift-based applications. It provides a protocol-oriented approach to define network endpoints, send requests, and handle responses. The package consists of protocols, extensions, enums, and a service class that conforms to the `Networkable` protocol for actual network requests.

## Components

### EndPoint Protocol
The `EndPoint` protocol defines the necessary components of a network request. Implement this protocol to specify the details of your network endpoints.

#### Properties
- `scheme`: The URL scheme, typically "http" or "https". The default is "https".
- `host`: The base URL's host component, e.g., "api.example.com".
- `path`: The specific path to the resource, e.g., "/users/1".
- `method`: The HTTP method to be used for the request, defined by the `RequestMethod` enum.
- `header`: A dictionary containing the HTTP headers. The default is an empty dictionary.
- `body`: The request body, conforming to `Encodable`. It's optional and defaults to `nil`.

### Networkable Protocol
The `Networkable` protocol outlines the functions required to send network requests and process responses.

#### Functions
- `sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T`: An asynchronous function that sends a request to the specified endpoint and returns a decodable type `T`.
- `sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, NetworkError>) -> Void)`: Sends a request and uses a completion handler to return the result.
- `sendRequest<T: Decodable>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError>`: Sends a request and returns a publisher for reactive programming.

### NetworkService
A class that conforms to the `Networkable` protocol, `NetworkService` is responsible for sending network requests as defined by the `EndPoint` instances.

### RequestMethod Enum
Defines HTTP methods available for requests, including `GET`, `POST`, `DELETE`, `PATCH`, `PUT`, and `OPTIONS`.

### NetworkError Enum
Represents potential errors that can occur during network requests, such as decoding errors, invalid URLs, unauthorized access, unexpected status codes, and more. Each case provides a descriptive error message.

### Extensions
Extensions on the `EndPoint` and `Networkable` protocols provide default implementations and utility functions to streamline request creation and handling.

#### EndPoint Extension
Provides default `scheme` and `header` properties to avoid repetitive code in conforming types.

#### Networkable Extension
Includes the `createRequest(endPoint:)` function, which constructs a `URLRequest` from an `EndPoint`. This function integrates URL components, HTTP method, headers, and request body into a single request object.

## Usage

1. **Define Endpoints**: Conform to the `EndPoint` protocol for each type of network request your application needs.

2. **Implement Networkable**: Use the provided `NetworkService` or create your own class that conforms to the `Networkable` protocol to handle the actual requests.

3. **Send Requests**: Use the `sendRequest` methods provided by `Networkable` to initiate network calls and handle responses either through async/await, completion handlers, or publishers depending on your app's architecture and requirements.

4. **Handle Errors**: Utilize the `NetworkError` enum to handle errors gracefully and provide meaningful feedback to the user.

NetworkKit's protocol-oriented design offers flexibility and reusability, making it a robust choice for networking in Swift applications.
