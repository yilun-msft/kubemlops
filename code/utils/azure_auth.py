import adal


def get_access_token(tenant, clientId, client_secret):
    authorityHostUrl = "https://login.microsoftonline.com"
    GRAPH_RESOURCE = '00000002-0000-0000-c000-000000000000'

    authority_url = authorityHostUrl + '/' + tenant

    context = adal.AuthenticationContext(authority_url)
    token = context.acquire_token_with_client_credentials(GRAPH_RESOURCE, clientId, client_secret)  # noqa: E501
    return token['accessToken']
