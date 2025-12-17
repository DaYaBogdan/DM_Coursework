<template>
  <main class="make-report-component">
    <div class="background">
      <RouterLink :to="{name: 'Книга жалоб'}">Закрыть окно</RouterLink>
      <div class="info">
        <div class="fields">
          <div class="text">На кого поступает жалоба?</div>
          <div class="flexed">
            <div class="text">Логин сотрудника:</div>
            <input placeholder="Логин" type="text" v-model="formData.reported" />
          </div>
          <div class="text">Опишите, по какой причине, данный сотрудник получает жалобу</div>
          <textarea placeholder="Жалоба" v-model="formData.description" />
        </div>
        <button @click="makeReport(formData.reported, formData.description)">Отправить жалобу</button>
      </div>
    </div>
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import router from "@/router";

const store = useStore();
const formData = {
  reported: "",
  description: "",
};

async function makeReport(reported, description) {
  store.commit("sendReport", {reported, description});
  await store.dispatch("setReports");
  router.push({name: "Книга жалоб"});
}
</script>

<style lang="scss" scoped>
.flexed {
  display: flex;
  flex-direction: row;
  justify-content: center;
}

.text {
  padding: 2rem;
  padding-right: 1rem;
}

input {
  width: 20rem;
  height: 2rem;
  border-radius: 0.5rem;
  padding: 1rem;
  font-family: var(--font);

  &::placeholder {
    text-align: center;
  }

  font-size: 1rem;
}

textarea {
  background-color: var(--light);
  width: 50rem;
  max-height: 30rem;

  &::placeholder {
    text-align: center;
  }

  font-size: 1rem;
}

textarea {
  font-size: 1rem;
  padding: 1rem;
  margin-bottom: 2rem;
  border-radius: 1rem;
}

a {
  color: var(--light);
  background-color: var(--dark);

  font-size: 2rem;
  border-radius: 0.5rem;
  width: fit-content;
  height: 3rem;
  padding: 0 2rem;
  margin: 3rem;

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
    background-color: var(--dark);

    font-size: 2rem;
    border-radius: 0.5rem;
    width: fit-content;
    height: 3rem;
    padding-left: 2rem;
    padding-right: 2rem;
    margin: 3rem;
  }
}

.flexed {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}

.flexed-all {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 2rem;
}

.text {
  padding: 2rem;
  padding-right: 1rem;
}

input {
  width: 20rem;
  height: 3rem;
  border-radius: 0.5rem;
  padding: 1rem;
  font-family: var(--font);
  background-color: var(--light);

  ::placeholder {
    color: var(--dark);
  }

  &::placeholder {
    text-align: center;
  }

  font-size: 1rem;
}
</style>
