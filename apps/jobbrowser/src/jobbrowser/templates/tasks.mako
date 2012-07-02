## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%
  from jobbrowser.views import get_state_link
  from desktop.views import commonheader, commonfooter
  from django.utils.translation import ugettext as _
%>

<%namespace name="comps" file="jobbrowser_components.mako" />

${commonheader(_('Task View: Job: %(jobId)s - Job Browser') % dict(jobId=jobid), "jobbrowser")}

<%def name="selected(val, state)">
    %   if val is not None and state is not None and val in state:
        selected="true"
    %   endif
</%def>
<div class="container-fluid">
    <h1>${_('Task View: Job: %(jobId)s') % dict(jobId=jobid)}</h1>
    <div class="well hueWell">
        <form method="get" action="/jobbrowser/jobs/${jobid}/tasks">
            <b>${_('Filter tasks:')}</b>

            <select name="taskstate" class="submitter">
                <option value="">${_('All states')}</option>
                <option value="succeeded" ${selected('succeeded', taskstate)}>${_('succeeded')}</option>
                <option value="running" ${selected('running', taskstate)}>${_('running')}</option>
                <option value="failed" ${selected('failed', taskstate)}>${_('failed')}</option>
                <option value="killed" ${selected('killed', taskstate)}>${_('killed')}</option>
                <option value="pending" ${selected('pending', taskstate)}>${_('pending')}</option>
            </select>


            <select name="tasktype" class="submitter">
                <option value="">${_('All types')}</option>
                <option value="map" ${selected('map', tasktype)}>${_('maps')}</option>
                <option value="reduce" ${selected('reduce', tasktype)}>${_('reduces')}</option>
                <option value="job_cleanup" ${selected('job_cleanup', tasktype)}>${_('cleanups')}</option>
                <option value="job_setup" ${selected('job_setup', tasktype)}>${_('setups')}</option>
            </select>


            <input type="text" name="tasktext"  class="submitter" title="${_('Text filter')}" placeholder="${_('Text Filter')}"
                % if tasktext:
                   value="${tasktext}"
                % endif
                    />
        </form>
    </div>


    % if len(page.object_list) == 0:
         <p>${_('There were no tasks that match your search criteria.')}</p>
    % else:
        <table class="datatables table table-striped table-condensed">
            <thead>
            <tr>
                <th>${_('Task ID')}</th>
                <th>${_('Type')}</th>
                <th>${_('Progress')}</th>
                <th>${_('Status')}</th>
                <th>${_('State')}</th>
                <th>${_('Start Time')}</th>
                <th>${_('End Time')}</th>
                <th>${_('View Attempts')}</th>
            </tr>
            </thead>
	        <tbody>
	            %for t in page.object_list:
	            <tr>
	                <td>${t.taskId_short}</td>
	                <td>${t.taskType}</td>
	                <td>
	                   <div class="bar">${"%d" % (t.progress * 100)}%</div>
	                </td>
	                <td>
	                    <a href="${url('jobbrowser.views.tasks', jobid=jobid)}?${get_state_link(request, 'taskstate', t.state.lower())}"
	                       title="${_('Show only %(state)s tasks') % dict(state=t.state.lower())}"
	                       class="${t.state.lower()}">${t.state.lower()}
	                    </a>
	                </td>
	                <td>${t.mostRecentState}</td>
	                <td>${t.execStartTimeFormatted}</td>
	                <td>${t.execFinishTimeFormatted}</td>
	                <td><a href="/jobbrowser/jobs/${jobid}/tasks/${t.taskId}" data-row-selector="true">${_('Attempts')}</a></td>
	            </tr>
	            %endfor
	        </tbody>
        </table>
    %endif
</div>

<script type="text/javascript" charset="utf-8">
    $(document).ready(function(){
        $(".datatables").dataTable({
            "bPaginate": false,
            "bLengthChange": false,
            "bFilter": false,
            "bInfo": false
        });
        $("a[data-row-selector='true']").jHueRowSelector();
    });
</script>

${commonfooter()}
