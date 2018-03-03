﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостями() <> Истина Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		// Если включено разделение данных, то редактировать новостные ленты можно только из неразделенного сеанса.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
			ЭтаФорма.ТолькоПросмотр = Ложь;
		Иначе
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
	Иначе
		ЭтаФорма.ТолькоПросмотр = Ложь;
	КонецЕсли;

	ЭтаФорма.РольДоступнаАдминистратор = ОбработкаНовостейПовтИсп.ЭтоАдминистратор();

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиЧерезИнтернет() = Истина Тогда
		Элементы.ДекорацияРежимРаботыСНовостямиЧерезИнтернет_ОбновлениеЛентНовостей.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.Свойство("ОткрытаИзОбработки_УправлениеНовостями") Тогда
		ЭтаФорма.ОткрытаИзОбработки_УправлениеНовостями = Параметры.ОткрытаИзОбработки_УправлениеНовостями;
	Иначе
		ЭтаФорма.ОткрытаИзОбработки_УправлениеНовостями = Ложь;
	КонецЕсли;

	ОбновитьИнформационныеСтроки();

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Обновились данные классификаторов новостей с сервера 1С" Тогда
		Элементы.Список.Обновить();
		ОбновитьИнформационныеСтроки();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьССервера(Команда)

	ОткрытьФорму(
		"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
		Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
		ЭтаФорма,
		"");

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)

	Если ВРег(НавигационнаяСсылка) = ВРег("Update") Тогда

		СтандартнаяОбработка = Ложь;

		ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылкиСервер();

		ОбновитьИнформационныеСтроки();

		ПоказатьОповещениеПользователя(
			НСтр("ru='Обновление завершено'"),
			,
			НСтр("ru='Обновление данных, а также последующая оптимизация загруженных данных завершены'"));

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузитьНовости(Команда)

	Если Команда.Имя = "КомандаЗагрузитьНовостиПоВсемЛентамНовостей" Тогда
		ОбработкаНовостейВызовСервера.ПолучитьИОбработатьНовостиПоЛентамНовостей(Новый Массив);
		Элементы.Список.Обновить();
		Оповестить(
			"Новости. Загружены новости",
			,
			ЭтаФорма.УникальныйИдентификатор);
	ИначеЕсли Команда.Имя = "КомандаЗагрузитьНовостиПоВыделеннымЛентамНовостей" Тогда
		МассивВыделенныхЛентНовостей = Новый Массив;
		Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
			МассивВыделенныхЛентНовостей.Добавить(Элементы.Список.ДанныеСтроки(ТекущаяСтрока).Ссылка);
		КонецЦикла;
		ОбработкаНовостейВызовСервера.ПолучитьИОбработатьНовостиПоЛентамНовостей(МассивВыделенныхЛентНовостей);
		Элементы.Список.Обновить();
		Оповестить(
			"Новости. Загружены новости",
			,
			ЭтаФорма.УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура обновляет все информационные надписи.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьИнформационныеСтроки()

	// Проверка необходимости обновления и вывод сообщения в декорации. Начало.

	ТребуетсяОбновление = Ложь;

	Запись = РегистрыСведений.ДатыОбновленияСтандартныхСписковНовостей.СоздатьМенеджерЗаписи();
	Запись.Список = "Список лент новостей"; // Идентификатор.
	Запись.Прочитать(); // Только чтение, без последующей записи.

	ЭтаФорма.ТекущаяВерсияНаКлиенте = Запись.ТекущаяВерсияНаКлиенте; // Для обновления без показа формы управления новостями.
	ЭтаФорма.ТекущаяВерсияНаСервере = Запись.ТекущаяВерсияНаСервере; // Для обновления без показа формы управления новостями.

	Если Запись.Выбран() Тогда
		Если Запись.ТекущаяВерсияНаКлиенте >= Запись.ТекущаяВерсияНаСервере Тогда
			ТекстНадписи = СтрШаблон(
				НСтр("ru='Данные актуальны и соответствуют данным с сервера от %1.'"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Ложь;
		Иначе // Устарели
			Если Запись.ТекущаяВерсияНаКлиенте = '00010101' Тогда
				ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера,
					|а на сервере уже версия от %2.'");
			Иначе
				ТекстНадписи = НСтр("ru='Последний раз данные обновлялись с сервера %1,
					|а на сервере уже версия от %2.'");
			КонецЕсли;
			ТекстНадписи = СтрШаблон(
				ТекстНадписи,
				Формат(Запись.ТекущаяВерсияНаКлиенте, "ДЛФ=DT"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Истина;
		КонецЕсли;
	Иначе
		ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера.'");
		ТребуетсяОбновление = Истина;
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("Новости_РазрешенаРаботаСНовостямиЧерезИнтернет") = Истина Тогда
		Если (ЭтаФорма.РольДоступнаАдминистратор = Истина) Тогда
			// Если эта форма открыта из формы обработки "Управление новостями", то
			//  не давать снова открывать форму обработки.
			Если ЭтаФорма.ОткрытаИзОбработки_УправлениеНовостями = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок = ТекстНадписи;
				Если ТребуетсяОбновление = Истина Тогда
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
				Иначе
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
				КонецЕсли;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = Новый ФорматированнаяСтрока(
					ТекстНадписи,
					" ",
					Новый ФорматированнаяСтрока(
						НСтр("ru='Проверить обновления'"),
						,
						ЦветаСтиля.ЦветГиперссылки,
						,
						"Update"),
					"."); // Завершающие предложение точки не должны попадать в гиперссылки.
			КонецЕсли;
		Иначе
			Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = ТекстНадписи;
			Если ТребуетсяОбновление = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// Проверка необходимости обновления и вывод сообщения в декорации. Конец.

КонецПроцедуры

&НаСервере
// Процедура запускает обновление лент новостей.
//
// Параметры:
//  Нет.
//
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылкиСервер()

	Обработки.УправлениеНовостями.ОбновитьСтандартныйСписокССервера(
		"Список лент новостей", // Идентификатор.
		ЭтаФорма.ТекущаяВерсияНаКлиенте,
		Неопределено);

	// После обновления лент новостей могли измениться наборы доступных для отбора категорий.
	// Удалить неправильные отборы, которые могут помешать проверке общих и пользовательских отборов.
	ОбработкаНовостей.ОптимизироватьОтборыПоНовостям();

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Частота обновления = 0 (обновлять вручную), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 0;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Обновлять только вручную'"));

		// Использование
		Элемент.Использование = Истина;

	// 2. Частота обновления = 1 (Ежедневно), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 1;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Ежедневно'"));

		// Использование
		Элемент.Использование = Истина;

	// 3. Частота обновления = 2 (Ежечасно), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 2;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Ежечасно'"));

		// Использование
		Элемент.Использование = Истина;

	// 4. Частота обновления = 3 (Каждые 15 минут), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 3;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Каждые 15 минут'"));

		// Использование
		Элемент.Использование = Истина;

	// 5. Частота обновления = 4 (Каждую минуту), и это НЕ локальная лента новостей.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЧастотаОбновления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 4;

		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Каждую минуту'"));

		// Использование
		Элемент.Использование = Истина;

	// 6. Частота обновления = не требуется, т.к. это локальная лента новостей
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЧастотаОбновления.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Не требуется'"));

		// Использование
		Элемент.Использование = Истина;

	// 7. Убрать колонки "Протокол", "Сайт", "ИмяФайла" если лента локальная.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Протокол.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сайт.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИмяФайла.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЛокальнаяЛентаНовостей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

#КонецОбласти

