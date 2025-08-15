FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

WORKDIR /src
COPY LevelUpDevOps.csproj .

RUN dotnet restore
COPY . .
RUN dotnet build -c Release
RUN dotnet test
RUN dotnet publish -c Release -o /dist

FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine

WORKDIR /dist

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:80

EXPOSE 80

COPY --from=build /dist .

CMD ["dotnet", "LevelUpDevOps.dll"]