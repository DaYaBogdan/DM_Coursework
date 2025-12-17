<template>
  <main class="account-page">
    <div class="info">
      <div class="account-info">
        <img :src="image" v-if="image" />
        <div class="centred">
          <div class="flexed">
            <div class="text form-text">Логин:</div>
            <input type="text" id="login" v-model="account.new_login" :disabled="disabled" />
          </div>
          <div class="flexed">
            <div class="text form-text">Пароль:</div>
            <input type="text" id="password" v-model="account.password" :disabled="disabled" />
          </div>
          <div class="flexed">
            <div class="text form-text">Фио:</div>
            <input type="text" id="FIO" v-model="account.fio" :disabled="disabled" />
          </div>
          <div class="flexed">
            <div class="text form-text">Телефон:</div>
            <input type="text" id="phone" v-model="account.phone" :disabled="disabled" />
          </div>
          <div class="flexed">
            <div class="text form-text">Почта:</div>
            <input type="text" id="email" v-model="account.email" :disabled="disabled" />
          </div>
          <div class="flexed">
            <button :hidden="props.withButtons" @click="disabled = !disabled">Внести изменения?</button>
            <button :hidden="props.withButtons" @click="store.commit('changeAccountProperties')">Сохранить изменения?</button>
          </div>
        </div>
      </div>
      <div>
        <div :hidden="props.withText" class="text">Внимание! Сохраняя изменения вы больше не сможете войти по бывшему паролю и логину.</div>
        <div :hidden="props.withText" class="text">
          Внимательно посмотрите, правильно ли указали изменения, если нужно сохраните данные в письменном виде или скриншотом
        </div>
      </div>
    </div>
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import {ref, onMounted, defineProps} from "vue";

const store = useStore();
const image = ref(null);
const account = ref(store.state.account);
const props = defineProps({
  withButtons: Boolean,
  withText: Boolean,
});

const disabled = ref(true);

onMounted(async () => {
  console.log(props.withButtons);
  console.log(props.withText);
  console.log(account.value.avatar_path);
  image.value = `http://localhost:8000/api/get_image/${account.value.avatar_path}`;
});
</script>

<style lang="scss" scoped>
input {
  width: 20rem;
  height: 3rem;
  border-radius: 0.5rem;
  margin-top: 0.5rem;
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

img {
  width: 18rem;
  height: 26rem;
  border-radius: 1rem;
}

.account-info {
  display: flex;
  flex-direction: row;
  justify-content: center;
  padding: 3rem;
  gap: 2rem;
}

.form-text {
  padding: 0rem;
  margin: 0rem;
}

.flexed {
  display: flex;
  flex-direction: row;
  gap: 2rem;
  justify-content: space-between;
}

.centred {
  align-content: center;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  gap: 2rem;
}

button {
  color: var(--light);
  background-color: var(--dark);
  font-size: 1rem;
  border-radius: 0.5rem;
  width: 14rem;
  height: 3rem;
  margin: 1rem;
}

input {
  width: 20rem;
  height: 2rem;
  border-radius: 0.5rem;
  padding: 1rem;
  font-family: var(--font);
  font-size: 1rem;

  &::placeholder {
    text-align: center;
  }
}
</style>
>
