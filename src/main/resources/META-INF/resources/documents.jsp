<%@ include file="/init.jsp" %>

<clay:navigation-bar
        inverted="<%= false %>"
        navigationItems='<%= dummyFactoryDisplayContext.getNavigationBarItems("Documents") %>'
/>

<div class="container-fluid container-fluid-max-xl container-view">
    <div class="sheet">
        <div class="panel-group panel-group-flush">
            <aui:fieldset>

                <liferay-ui:success key="success" message="Documents created successfully"/>
                <%@ include file="/command_select.jspf" %>

                <portlet:actionURL name="<%= LDFPortletKeys.DOCUMENTS %>" var="documentEditURL">
                    <portlet:param name="<%= LDFPortletKeys.MODE %>" value="<%=LDFPortletKeys.MODE_DOCUMENTS %>"/>
                    <portlet:param name="redirect" value="<%=portletURL.toString()%>"/>
                </portlet:actionURL>
                <div id="<portlet:namespace />Header0" role="tab">
                    <div aria-controls="<portlet:namespace />Collapse0" aria-expanded="false"
                         class="collapse-icon collapse-icon-middle panel-toggler" data-toggle="liferay-collapse"
                         href="#<portlet:namespace />Collapse0" role="button">
                        <h1>Create Documents <small><liferay-ui:icon-help message="usage"/></small></h1>
                    </div>
                </div>

                <div aria-expanded="false" aria-labelledby="<portlet:namespace />Header0"
                     class="collapse panel-collapse" id="<portlet:namespace />Collapse0" role="tabpanel">
                    <div class="alert alert-info">
                        <h4>Example</h4>
                        <p>if you enter the values <code>3</code> and <code>doc</code> the portlet will create three
                            documents: <code>doc1</code>, <code>doc2</code>, and <code>doc3</code>.
                        <p>
                        <hr class="separator" />
                        <ul>
                            <li>You must be signed in as an administrator in order to create documents
                            <li>
                            <li>The counter always starts at <code>1</code></li>
                            <li>If no site is selected, the default site will be <code>liferay.com</code>
                            <li>
                        </ul>
                    </div>
                </div>

                <%
                    String numberOfDocumentsLabel = "Enter the number of documents you would like to create";
                    String baseDocumentTitleLabel = "Enter the base document title (i.e. doc, newDoc, testDoc)";
                    String baseDocumentDescriptionLabel = "Enter the base document description";
                    String defaultOption = "(None)";
                    String groupIdLabel = "Select a site to assign the documents to";
                    String dlFolderIdLabel = "Select a folder where the document is created";
                    String uploadFieldText = "Upload files here to be used for generating dummy documents. Multiple files uploaded will be randomly used with the original extention ";
                    List<Group> groups = GroupLocalServiceUtil.getGroups(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
                    final String groupName = GroupConstants.GUEST;
                    final long companyId = PortalUtil.getDefaultCompanyId();
                    final long guestGroupId = GroupLocalServiceUtil.getGroup(companyId, groupName).getGroupId();
                %>

                <aui:form action="<%= documentEditURL %>" method="post" name="fm"
                          onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "execCommand();" %>'>
                    <aui:input name="<%= LDFPortletKeys.COMMON_PROGRESS_ID %>" value="<%= progressId %>" type="hidden"/>

                    <aui:input name="numberOfDocuments" label="<%= numberOfDocumentsLabel %>">
                        <aui:validator name="digits"/>
                        <aui:validator name="min">1</aui:validator>
                        <aui:validator name="required"/>
                    </aui:input>
                    <aui:input name="baseDocumentTitle" label="<%= baseDocumentTitleLabel %>"
                               cssClass="lfr-textarea-container">
                        <aui:validator name="required"/>
                    </aui:input>
                    <aui:select name="groupId" label="<%= groupIdLabel %>">
                        <aui:option label="<%= defaultOption %>" value="<%= guestGroupId %>" selected="<%= true %>"/>
                        <%
                            for (Group group : groups) {
                                if (group.isSite() && !group.getDescriptiveName().equals("Control Panel")) {
                        %>
                        <aui:option label="<%= group.getDescriptiveName() %>" value="<%= group.getGroupId() %>"/>
                        <%
                                }
                            }
                        %>
                    </aui:select>
                    <aui:select name="folderId" label="<%= dlFolderIdLabel %>">
                        <aui:option label="<%= defaultOption %>"
                                    value="<%= String.valueOf(DLFolderConstants.DEFAULT_PARENT_FOLDER_ID) %>"/>
                    </aui:select>


                    <div class="panel panel-secondary">
                        <div class="panel-header panel-heading" id="<portlet:namespace />Header" role="tab">
                            <div class="panel-title">
                                <div aria-controls="<portlet:namespace />Collapse" aria-expanded="false"
                                     class="collapse-icon collapse-icon-middle panel-toggler" data-toggle="liferay-collapse"
                                     href="#<portlet:namespace />Collapse" role="button">
                                    <span class="category-name text-truncate">Click here to show more options</span>
                                    <aui:icon cssClass="collapse-icon-closed" image="angle-right" markupView="lexicon"/>
                                    <aui:icon cssClass="collapse-icon-open" image="angle-down" markupView="lexicon"/>
                                </div>
                            </div>
                        </div>

                        <div aria-expanded="false" aria-labelledby="<portlet:namespace />Header"
                             class="collapse panel-collapse" id="<portlet:namespace />Collapse" role="tabpanel">
                            <div class="simulation-app-panel-body">
                                <div class="row">
                                    <aui:fieldset cssClass="col-md-12">
                                        <aui:row>
                                            <aui:col width="<%= 80 %>">
                                                <aui:field-wrapper label="<%= uploadFieldText %>">
                                                </aui:field-wrapper>
                                                <div class="lfr-dynamic-uploader">
                                                    <div class="lfr-upload-container"
                                                         id="<portlet:namespace />fileUpload"></div>
                                                </div>

                                                <liferay-util:buffer var="removeAttachmentIcon">
                                                    <liferay-ui:icon
                                                            iconCssClass="icon-remove"
                                                    />
                                                </liferay-util:buffer>

                                                <liferay-portlet:actionURL doAsUserId="<%= user.getUserId() %>"
                                                                           name="/df/document/upload_multiple_file_entries"
                                                                           var="delteFileEntryURL">
                                                    <portlet:param name="<%= Constants.CMD %>"
                                                                   value="<%= Constants.DELETE_TEMP %>"/>
                                                    <portlet:param name="folderId" value="0"/>
                                                    <portlet:param name="redirect"
                                                                   value="<%= PortalUtil.getCurrentURL(request) %>"/>
                                                </liferay-portlet:actionURL>

                                                <liferay-portlet:actionURL doAsUserId="<%= user.getUserId() %>"
                                                                           name="/df/document/upload_multiple_file_entries"
                                                                           var="addFileEntryURL">
                                                    <portlet:param name="<%= Constants.CMD %>"
                                                                   value="<%= Constants.ADD_TEMP %>"/>
                                                    <portlet:param name="folderId" value="0"/>
                                                    <portlet:param name="redirect"
                                                                   value="<%= PortalUtil.getCurrentURL(request) %>"/>
                                                </liferay-portlet:actionURL>

                                                <%
                                                    Date expirationDate = new Date(System.currentTimeMillis() + PropsValues.SESSION_TIMEOUT * Time.MINUTE);

                                                    Ticket ticket = TicketLocalServiceUtil.addTicket(user.getCompanyId(), User.class.getName(), user.getUserId(), TicketConstants.TYPE_IMPERSONATE, null, expirationDate, new ServiceContext());
                                                    DLConfiguration dlConfiguration = ConfigurationProviderUtil.getSystemConfiguration(DLConfiguration.class);
                                                %>

                                                <aui:script use="liferay-upload">
                                                    var uploader = new Liferay.Upload(
                                                    {
                                                    boundingBox: '#<portlet:namespace/>fileUpload',

                                                    <%
                                                        DecimalFormatSymbols decimalFormatSymbols = DecimalFormatSymbols.getInstance(locale);
                                                    %>

                                                    decimalSeparator: '<%= decimalFormatSymbols.getDecimalSeparator() %>',
                                                    deleteFile: '<%=delteFileEntryURL%>&ticketKey=<%= ticket.getKey() %><liferay-ui:input-permissions-params
                                                        modelName="<%= DLFileEntryConstants.getClassName() %>"/>',
                                                    fileDescription: '<%= StringUtil.merge(dlConfiguration.fileExtensions()) %>',
                                                    maxFileSize: '<%= UploadServletRequestConfigurationProviderUtil.getMaxSize() %> B',
                                                    metadataContainer: '#<portlet:namespace/>commonFileMetadataContainer',
                                                    metadataExplanationContainer: '#<portlet:namespace/>metadataExplanationContainer',
                                                    namespace: '<portlet:namespace/>',
                                                    tempFileURL: {
                                                    method: Liferay.Service.bind('/dlapp/get-temp-file-names'),
                                                    params: {
                                                    folderId: <%= String.valueOf(DLFolderConstants.DEFAULT_PARENT_FOLDER_ID) %>,
                                                    folderName: '<%= EditFileEntryMVCActionCommand.TEMP_FOLDER_NAME %>',
                                                    groupId: document.getElementById("<portlet:namespace/>groupId").value,
                                                    }
                                                    },
                                                    tempRandomSuffix: '<%= TempFileEntryUtil.TEMP_RANDOM_SUFFIX %>',
                                                    uploadFile: '<%=addFileEntryURL%>&ticketKey=<%= ticket.getKey() %><liferay-ui:input-permissions-params
                                                        modelName="<%= DLFileEntryConstants.getClassName() %>"/>'
                                                    }
                                                    );

                                                    uploader.on(
                                                    'uploadComplete',
                                                    function(event) {
                                                    console.log(event);
                                                    }
                                                    );
                                                </aui:script>
                                            </aui:col>
                                        </aui:row>

                                        <aui:input name="baseDocumentDescription"
                                                   label="<%= baseDocumentDescriptionLabel %>"
                                                   cssClass="lfr-textarea-container" type="textarea" wrap="soft"/>
                                    </aui:fieldset>
                                </div>

                            </div>
                        </div>
                    </div>

                    <aui:button-row>
                        <aui:button type="submit" value="Run" cssClass="btn-lg btn-block btn-primary" id="processStart"/>
                    </aui:button-row>
                </aui:form>

                <%
                    // Because of bug of lifeary-ui:upload-progress, you need to add the following parameter in the request.
                    String progressSessionKey = ProgressTracker.PERCENT + progressId;
                    request.setAttribute("liferay-document-library:progress:sessionKey", progressSessionKey);
                %>
                <liferay-document-library:upload-progress
                        id="<%= progressId %>"
                        message="creating..."
                        height="20"
                />

            </aui:fieldset>
        </div>
    </div>

</div>

<script type="text/html" id="<portlet:namespace />journal_folder_options">
    <option value="<@= folderId @>"><@= name @></option>
</script>

<aui:script>
    function <portlet:namespace/>execCommand() {

        submitForm(document.<portlet:namespace/>fm);
    }
</aui:script>

<aui:script use="aui-base,liferay-form">
    var handleClick = function (event) {
        Liferay.Service(
            '/dlfolder/get-folders',
            {
                groupId: document.getElementById('<portlet:namespace/>groupId').value,
                parentFolderId: "<%= String.valueOf(DLFolderConstants.DEFAULT_PARENT_FOLDER_ID) %>",
                start: -1,
                end: -1,
                "+obc": "com.liferay.document.library.kernel.util.comparator.FolderIdComparator"
            },
            function (dataIn) {
                var data = dataIn;

                //Load Template
                Liferay.Loader.require("<%=lodashResolver %>", function (_lodash) {
                    (function () {
                        var _ = _lodash;

                        var tmpl = _.template(document.getElementById('<portlet:namespace/>journal_folder_options').innerHTML);
                        var listAll = tmpl({
                            folderId: "<%= String.valueOf(DLFolderConstants.DEFAULT_PARENT_FOLDER_ID) %>",
                            name: "(None)",
                            selected: "true"
                        });

                        _.map(data, function (n) {
                            listAll +=
                                tmpl(
                                    {
                                        folderId: (n.folderId) ? _.escape(n.folderId) : "",
                                        name: (n.name) ? _.escape(n.name) : "",
                                        selected: "false"
                                    }
                                );
                        });
                        var catObj = document.getElementById('<portlet:namespace/>folderId');
                        catObj.empty();
                        catObj.append(listAll);

                    })()
                }, function (error) {
                    console.error(error)
                });

            }
        );
    }

    // Register listeners to the dom
    var elm = document.createElement("<portlet:namespace/>groupId");
    elm.addEventListener("change load", handleClick);
</aui:script>
