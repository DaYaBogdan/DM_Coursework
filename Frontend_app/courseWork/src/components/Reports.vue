<template>
  <main class="Reports-page">
    <div class="info">
      <div class="reports">
        <Report
          class="report"
          v-for="report in store.state.reports"
          :descriprion="report.descriprion"
          :reported="report.reported"
          :reporter="report.reporter"
        />
      </div>
    </div>
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import Report from "./Report.vue";

const store = useStore();

store.commit("getReports");
</script>

<style lang="scss" scoped>
.reports {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
</style>
