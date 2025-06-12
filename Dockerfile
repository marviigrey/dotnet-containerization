# build "server" image
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

WORKDIR /src

COPY LevelUpDevOps.slnx .
COPY LevelUpDevOps.csproj .
RUN dotnet restore LevelUpDevOps.slnx
COPY . .
RUN dotnet build -c Release LevelUpDevOps.slnx
RUN dotnet test -c Release LevelUpDevOps.slnx
RUN dotnet publish -c Release -o /dist LevelUpDevOps.csproj

# production runtime "server" image
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine

ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ConnectionStrings__MyDB=""

WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "LevelUpDevOps.dll"]
