<template>
  <main class="Reports-page">
    <div class="info">
      <div class="buttons">
        <RouterLink :to="{name: 'Сделать жалобу'}">Разместить жалобу</RouterLink>
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
    <RouterView />
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import Report from "./Report.vue";

const store = useStore();
</script>

<style lang="scss" scoped>
a {
  color: var(--light);
  background-color: var(--dark);

  font-size: 2rem;
  border-radius: 0.5rem;
  width: fit-content;
  height: 3rem;
  padding: 0 2rem;

  text-decoration: none;
  border: none;
  outline: none;
  display: inline-flex;
  align-items: center;

  &.router-link-active,
  &.router-link-exact-active {
    color: var(--light);
    background-color: var(--dark);
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
