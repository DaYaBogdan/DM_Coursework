<template>
  <main class="Reports-page">
    <div :hidden="makingReport">
      <div class="background">
        <button @click="makingReport = !makingReport">Закрыть окно</button>
        <MakeReport />
      </div>
    </div>
    <div class="info">
      <div class="buttons">
        <button @click="makingReport = !makingReport">Разместить жалобу</button>
      </div>
      <div class="reports">
        <Report
          class="report"
          v-for="report in store.state.reports"
          :description="report.description"
          :reported="report.reported"
          :reporter="report.reporter"
          :key="report"
        />
      </div>
    </div>
  </main>
</template>

<script setup>
import {ref} from "vue";
import {useStore} from "vuex";
import Report from "./Report.vue";
import MakeReport from "./MakeReport.vue";

const store = useStore();
const makingReport = ref(true);

store.commit("getReports");
</script>

<style lang="scss" scoped>
.background {
  position: fixed;
  top: 0;
  left: 0px;
  padding: 3rem;
  margin: 0;
  right: 0;
  z-index: 2;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);

  display: flex;
  flex-direction: column;

  button {
    color: var(--light);
    background-color: var(--dark-alt);

    font-size: 2rem;
    border-radius: 0.5rem;
    width: fit-content;
    height: 3rem;
    padding-left: 2rem;
    padding-right: 2rem;
    margin: 3rem;
  }
}

a {
  text-decoration: none;
  &:link {
    color: var(--light);
  }
  &:visited {
    color: var(--primary);
  }
}

.buttons {
  display: flex;
  justify-content: space-between;
  flex-direction: row;
  padding: 2rem;

  button {
    color: var(--light);
    background-color: var(--dark);
    font-size: 2rem;
    border-radius: 0.5rem;
    width: fit-content;
    height: 3rem;
    // margin: 1rem;
    padding-left: 1rem;
    padding-right: 1rem;

    .text {
      padding: 0;
      margin: 0;
    }
  }
}

.reports {
  display: grid;
  grid-template-columns: repeat(2, 2fr);
  justify-content: space-between;
}
</style>
