<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import RepoPreviousDirectory from './repo_prev_directory.vue';
import RepoFile from './repo_file.vue';
import RepoLoadingFile from './repo_loading_file.vue';

export default {
  components: {
    'repo-previous-directory': RepoPreviousDirectory,
    'repo-file': RepoFile,
    'repo-loading-file': RepoLoadingFile,
  },
  props: {
    treeId: {
      type: String,
      required: true,
    },
  },
  computed: {
    ...mapState([
      'loading',
      'isRoot',
    ]),
    ...mapState({
      projectName(state) {
        return state.project.name;
      },
    }),
    ...mapGetters([
      'treeList',
      'isCollapsed',
    ]),
  },
};
</script>

<template>
<div>
<div id="sidebar">
  <table class="table">
    <thead>
      <tr>
        <th
          v-if="isCollapsed"
          class="repo-file-options title"
        >
          <strong class="clgray">
            {{ projectName }}
          </strong>
        </th>
        <template v-else>
          <th class="name multi-file-table-col-name">
            Name
          </th>
          <th class="hidden-sm hidden-xs last-commit">
            Last commit
          </th>
          <th class="hidden-xs last-update text-right">
            Last update
          </th>
        </template>
      </tr>
    </thead>
    <tbody
      v-if="treeId">
      <repo-previous-directory
        v-if="!isRoot && treeList(treeId).length"
      />
      <repo-loading-file
        v-if="(!treeId || !treeList(treeId).length) && loading"
        v-for="n in 5"
        :key="n"
      />
      <repo-file
        v-for="(file, index) in treeList(treeId)"
        :key="file.key"
        :file="file"
      />
    </tbody>
  </table>
</div>
</div>
</template>
