<script setup>
import {useStore} from "vuex";
import Sidebar from "@/components/Sidebar.vue";
import {RouterView} from "vue-router";
import {onMounted} from "vue";

const store = useStore();

store.commit("setTypes");
store.commit("setAccount");

onMounted(() => {
  store.dispatch("setOrders");
  store.dispatch("setReports");
  setInterval(() => {
    store.dispatch("setOrders");
    store.dispatch("setReports");
  }, 10000);
});
</script>

<template>
  <div class="app">
    <Sidebar />
    <RouterView />
  </div>
</template>

<style lang="scss">
:root {
  --primary: #00eeff;
  --primary-alt: #b810da;
  --grey: #64748b;
  --dark: #1e293b;
  --dark-alt: #334155;
  --light: #f1f5f9;
  --error: #6f0a03;
  --accept: #168019;
  --sidebar-width: 300px;
  --font: "Fira sans", sans-serif;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: var(--font);
}

body {
  background: var(--light);
}

button {
  cursor: pointer;
  appearance: none;
  border: none;
  outline: none;
  background: none;
}

.app {
  display: flex;

  main {
    flex: 1 1 0;
    padding: 2rem;

    @media (max-width: 768px) {
      padding-left: 6rem;
    }
  }
}

.info {
  margin: 1rem;
  border-radius: 15px;
  text-align: center;
  min-height: 30rem;
  box-shadow: 0.5rem 0rem 1rem var(--primary);
  background-color: var(--dark-alt);
  color: var(--light);

  .text {
    font-size: 2rem;
    padding: 3rem;
  }
}

.aligned-info {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  justify-content: center;

  .info {
    border: 1px solid #000;
    height: 2rem;
  }
}
</style>
