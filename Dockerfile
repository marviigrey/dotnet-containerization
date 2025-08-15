FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

WORKDIR /src
COPY LevelUpDevOps.csproj .

RUN dotnet restore
COPY . .
RUN dotnet build LevelUpDevOps.csproj -c Release
RUN dotnet test LevelUpDevOps.csproj
RUN dotnet publish LevelUpDevOps.csproj -c Release -o /dist

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

WORKDIR /dist

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:80

EXPOSE 80

COPY --from=build /dist .

CMD ["dotnet", "LevelUpDevOps.dll"]