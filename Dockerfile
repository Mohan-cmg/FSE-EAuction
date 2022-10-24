#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["EAuction.Api/EAuction.Api.csproj", "EAuction.Api/"]
RUN dotnet restore "EAuction.Api/EAuction.Api.csproj"
COPY . .
WORKDIR "/src/EAuction.Api"
RUN dotnet build "EAuction.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EAuction.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EAuction.Api.dll"]