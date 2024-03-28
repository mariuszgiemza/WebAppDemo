 FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
 WORKDIR /app
 EXPOSE 5151

 ENV ASPNETCORE_URLS=http://+:5151

 FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
 ARG configuration=Release
 WORKDIR /src
 COPY ["webappdemo.csproj", "./"]
 RUN dotnet restore "webappdemo.csproj"
 COPY . .
 WORKDIR "/src/."
 RUN dotnet build "webappdemo.csproj" -c $configuration -o /app/build

 FROM build AS publish
 ARG configuration=Release
 RUN dotnet publish "webappdemo.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

 FROM base AS final
 WORKDIR /app
 COPY --from=publish /app/publish .
 ENTRYPOINT ["dotnet", "webappdemo.dll"]
