###
# Copyright (C) 2014-2017 Taiga Agile LLC <taiga@taiga.io>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: wiki-history.service.coffee
###

taiga = @.taiga

module = angular.module('taigaWikiHistory')

class WikiHistoryService extends taiga.Service
    @.$inject = [
        "tgResources"
        "tgXhrErrorService"
    ]

    constructor: (@rs, @xhrError) ->
        @._wikiId = null
        @._historyEntries = Immutable.List()
        @._visibleHistoryEntries = Immutable.List()
        @._historyEntriesVisible = false

        taiga.defineImmutableProperty @, "wikiId", () => return @._wikiId
        taiga.defineImmutableProperty @, "historyEntries", () => return @._historyEntries
        taiga.defineImmutableProperty @, "visibleHistoryEntries", () => return @._visibleHistoryEntries
        taiga.defineImmutableProperty @, 'historyEntriesVisible', () => return @._historyEntriesVisible

    setWikiId: (wikiId) ->
        @._wikiId = wikiId
        @._historyEntries = Immutable.List()
        @._visibleHistoryEntries = Immutable.List()

    loadHistoryEntries: () ->
        return if not @._wikiId

        return @rs.wikiHistory.getWikiHistory(@._wikiId)
            .then (historyEntries) =>
                if historyEntries.size
                    @._historyEntries = historyEntries.reverse()
                    @.regenerate()
            .catch (xhr) =>
                @xhrError.response(xhr)
    _

    toggleHistoryEntriesVisible: () ->
        @._historyEntriesVisible = !@._historyEntriesVisible
        @.regenerate()

    regenerate: () ->
        if @._historyEntriesVisible
            @._visibleHistoryEntries = @._historyEntries
        else
            @._visibleHistoryEntries = Immutable.List()

module.service("tgWikiHistoryService", WikiHistoryService)
