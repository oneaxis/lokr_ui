# LOKR UI

An easy to use UI for the personal secret management. Functioning as a visualization and client
side encryption framework for LOKR API.

## Development
### JSON Serialization
To generate code for JSON serialization, follow the official [guide](https://pub.dev/packages/json_serializable).
> NOTE: you need to add the `part` declaration aswell, containing the filename of your newly
> generated serialization code file (e.g. person.g.dart)

Then run:
```bash
flutter pub run build_runner build
```

### Mock
To get life into your application and fill it with mock data, use (see [docker-compose.yaml](./pact-stub-server/docker-compose.yaml)):
```bash
docker-compose up 
```

### Environments
To use a specific environment, provide a `.env` at the projects top level. Example `.env` files are 
located in [environments](./environments) (don't forget to rename the files).