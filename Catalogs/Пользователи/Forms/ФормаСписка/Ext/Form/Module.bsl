﻿////////////////////////////////////////////////////////////////////////////////
//                          ИСПОЛЬЗОВАНИЕ ФОРМЫ                               //
//
// Дополнительные параметры открытия формы подбора:
//
// РасширенныйПодбор - Булево - если Истина - открывается расширенная форма
//  подбора пользователей. Используется вместе с параметром.
//  ПараметрыРасширеннойФормыПодбора.
// ПараметрыРасширеннойФормыПодбора - Строка - ссылка на структуру,
//  содержащую параметры расширенной формы подбора во
//  временном хранилище.
//  Параметры структуры:
//    ЗаголовокФормыПодбора - Строка - заголовок формы подбора.
//    ВыбранныеПользователи - Массив - массив уже выбранных пользователей.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Начальное значение настройки до загрузки данных из настроек.
	ВыбиратьИерархически = Истина;
	
	ЗаполнитьХранимыеПараметры();
	
	Если Параметры.РежимВыбора Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
	ИначеЕсли Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Добавление отбора пользователей, подготовленных ответственным за список.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок, "Подготовлен", Истина, ,
			НСтр("ru = 'Подготовленные ответственным за список'"), Ложь,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	КонецЕсли;
	
	// Скрытие пользователей с пустым идентификатором, если значение параметра Истина.
	Если Параметры.СкрытьПользователейБезПользователяИБ Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок,
			"ИдентификаторПользователяИБ",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЕсли;
	
	// Скрытие служебных пользователей.
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок, "Служебный", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			Строка(Новый УникальныйИдентификатор));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок, "Служебный", Ложь, , , Истина);
	КонецЕсли;
	
	// Скрытие переданного пользователя из формы выбора пользователей.
	Если ТипЗнч(Параметры.СкрываемыеПользователи) = Тип("СписокЗначений") Тогда
		
		ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСписке;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок,
			"Ссылка",
			Параметры.СкрываемыеПользователи,
			ВидСравненияКД);
		
	КонецЕсли;
	
	ОформитьИСкрытьНедействительныхПользователей();
	НастроитьПараметрыСпискаПользователейДляКомандыУстановитьПароль();
	НастроитьПорядокГруппыВсеПользователи(ГруппыПользователей);
	
	ХранимыеПараметры.Вставить("РасширенныйПодбор", Параметры.РасширенныйПодбор);
	Элементы.ВыбранныеПользователиИГруппы.Видимость = ХранимыеПараметры.РасширенныйПодбор;
	ХранимыеПараметры.Вставить(
		"ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.Пользователи) Тогда
		Элементы.СоздатьПользователя.Видимость = Ложь;
	КонецЕсли;
	
	РазделениеВключено = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Не РазделениеВключено) Тогда
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		Элементы.СведенияОПользователях.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
	
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		Элементы.СведенияОПользователях.Видимость = Ложь;
		Элементы.ГруппыПользователей.РежимВыбора = ХранимыеПараметры.ВыборГруппПользователей;
		// Отключение перетаскивания пользователя в формах выбора и подбора пользователей.
		Элементы.ПользователиСписок.РазрешитьНачалоПеретаскивания = Ложь;
		
		Если Параметры.Свойство("ИдентификаторыНесуществующихПользователейИБ") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ПользователиСписок, "ИдентификаторПользователяИБ",
				Параметры.ИдентификаторыНесуществующихПользователейИБ,
				ВидСравненияКомпоновкиДанных.ВСписке, , Истина,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		КонецЕсли;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.ПользователиСписок.МножественныйВыбор = Истина;
			
			Если ХранимыеПараметры.РасширенныйПодбор Тогда
				СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "РасширенныйПодбор");
				ИзменитьПараметрыРасширеннойФормыПодбора();
			КонецЕсли;
			
			Если ХранимыеПараметры.ВыборГруппПользователей Тогда
				Элементы.ГруппыПользователей.МножественныйВыбор = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ПользователиСписок.РежимВыбора  = Ложь;
		Элементы.ГруппыПользователей.РежимВыбора = Ложь;
		Элементы.Комментарии.Видимость = Ложь;
		Элементы.ВыбратьПользователя.Видимость = Ложь;
		Элементы.ВыбратьГруппуПользователей.Видимость = Ложь;
	КонецЕсли;
	
	ХранимыеПараметры.Вставить("ГруппаВсеПользователи", Справочники.ГруппыПользователей.ВсеПользователи);
	ХранимыеПараметры.Вставить("ТекущаяСтрока", Параметры.ТекущаяСтрока);
	НастроитьФормуПоИспользованиюГруппПользователей();
	ХранимыеПараметры.Удалить("ТекущаяСтрока");
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов")
	 Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.ПользователиСписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	ОписаниеОбъекта = Новый Структура;
	ОписаниеОбъекта.Вставить("Ссылка", Справочники.Пользователи.ПустаяСсылка());
	ОписаниеОбъекта.Вставить("ИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	УровеньДоступа = ПользователиСлужебный.УровеньДоступаКСвойствамПользователя(ОписаниеОбъекта);
	
	Если Не УровеньДоступа.УправлениеСписком Тогда
		Элементы.ФормаУстановитьПароль.Видимость = Ложь;
		Элементы.ПользователиСписокКонтекстноеМенюУстановитьПароль.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
		Элементы.ГруппыПользователей.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	//++ НЕ ГИСМ
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	//-- НЕ ГИСМ
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.РежимВыбора Тогда
		ПроверкаИзмененияТекущегоЭлементаФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыПользователей")
	   И Источник = Элементы.ГруппыПользователей.ТекущаяСтрока Тогда
		
		Элементы.ПользователиСписок.Обновить();
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_НаборКонстант") Тогда
		
		Если ВРег(Источник) = ВРег("ИспользоватьГруппыПользователей") Тогда
			ПодключитьОбработчикОжидания("ПриИзмененииИспользованияГруппПользователей", 0.1, Истина);
		КонецЕсли;
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("РазмещениеПользователейВГруппах") Тогда
		
		Элементы.ПользователиСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ТипЗнч(Настройки["ВыбиратьИерархически"]) = Тип("Булево") Тогда
		ВыбиратьИерархически = Настройки["ВыбиратьИерархически"];
	КонецЕсли;
	
	Если НЕ ВыбиратьИерархически Тогда
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователейПриИзменении(Элемент)
	ПереключитьОтображениеНедействительныхПользователей(ПоказыватьНедействительныхПользователей);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыПользователей

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ГруппыПользователейПослеАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(Элементы.ГруппыПользователей.ТекущаяСтрока) Тогда
			ПараметрыФормы.Вставить(
				"ЗначенияЗаполнения",
				Новый Структура("Родитель", Элементы.ГруппыПользователей.ТекущаяСтрока));
		КонецЕсли;
		
		ОткрытьФорму(
			"Справочник.ГруппыПользователей.ФормаОбъекта",
			ПараметрыФормы,
			Элементы.ГруппыПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбиратьИерархически Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Для перетаскивания пользователя в группы необходимо отключить
			           |флажок ""Показывать пользователей нижестоящих групп"".'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы.ГруппыПользователей.ТекущаяСтрока = Строка
		Или Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
		Перемещение = Истина;
	Иначе
		Перемещение = Ложь;
	КонецЕсли;
	
	ГруппаПомеченаНаУдаление = Элементы.ГруппыПользователей.ДанныеСтроки(Строка).ПометкаУдаления;
	КоличествоПользователей = ПараметрыПеретаскивания.Значение.Количество();
	
	ДействиеИсключитьПользователя = (ХранимыеПараметры.ГруппаВсеПользователи = Строка);
	
	ДействиеСПользователем = ?((ХранимыеПараметры.ГруппаВсеПользователи = Элементы.ГруппыПользователей.ТекущаяСтрока),
		НСтр("ru = 'Включить'"),
		?(Перемещение, НСтр("ru = 'Переместить'"), НСтр("ru = 'Скопировать'")));
	
	Если ГруппаПомеченаНаУдаление Тогда
		ШаблонДействия = ?(Перемещение,
			НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"),
			НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"));
		ДействиеСПользователем = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонДействия, Строка(Строка), ДействиеСПользователем);
	КонецЕсли;
	
	Если КоличествоПользователей = 1 Тогда
		Если ДействиеИсключитьПользователя Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Исключить пользователя ""%1"" из группы ""%2""?'"),
				Строка(ПараметрыПеретаскивания.Значение[0]),
				Строка(Элементы.ГруппыПользователей.ТекущаяСтрока));
			
		ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 пользователя ""%2"" в группу ""%3""?'"),
				ДействиеСПользователем,
				Строка(ПараметрыПеретаскивания.Значение[0]),
				Строка(Строка));
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 пользователя ""%2"" в эту группу?'"),
				ДействиеСПользователем,
				Строка(ПараметрыПеретаскивания.Значение[0]));
		КонецЕсли;
	Иначе
		Если ДействиеИсключитьПользователя Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Исключить пользователей (%1) из группы ""%2""?'"),
				КоличествоПользователей,
				Строка(Элементы.ГруппыПользователей.ТекущаяСтрока));
			
		ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 пользователей (%2) в группу ""%3""?'"),
				ДействиеСПользователем,
				КоличествоПользователей,
				Строка(Строка));
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 пользователей (%2) в эту группу?'"),
				ДействиеСПользователем,
				КоличествоПользователей);
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыПеретаскивания", ПараметрыПеретаскивания.Значение);
	ДополнительныеПараметры.Вставить("Строка", Строка);
	ДополнительныеПараметры.Вставить("Перемещение", Перемещение);
	
	Оповещение = Новый ОписаниеОповещения("ГруппыПользователейПеретаскиваниеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Элементы.ГруппыПользователей.ТолькоПросмотр Тогда
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользователиСписок

&НаКлиенте
Процедура ПользователиСписокПриАктивизацииСтроки(Элемент)
	
	Если СтандартныеПодсистемыКлиент.ЭтоЭлементДинамическогоСписка(Элементы.ПользователиСписок) Тогда
		ВозможноСменитьПароль = Элементы.ПользователиСписок.ТекущиеДанные.ВозможноСменитьПароль;
	Иначе
		ВозможноСменитьПароль = Ложь;
	КонецЕсли;
	
	Элементы.ФормаУстановитьПароль.Доступность = ВозможноСменитьПароль;
	Элементы.ПользователиСписокКонтекстноеМенюУстановитьПароль.Доступность = ВозможноСменитьПароль;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ГруппаНовогоПользователя", Элементы.ГруппыПользователей.ТекущаяСтрока);
	
	Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта", ПараметрыФормы, Элементы.ПользователиСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Не ЗначениеЗаполнено(Элемент.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
	ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВыбранныхПользователейИГрупп

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	УдалитьИзСпискаВыбранных();
	СписокВыбранныхПользователейИзменен = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьГруппуПользователей(Команда)
	
	Элементы.ГруппыПользователей.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьГруппы(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователи", Элементы.ПользователиСписок.ВыделенныеСтроки);
	ПараметрыФормы.Вставить("ВнешниеПользователи", Ложь);
	
	ОткрытьФорму("ОбщаяФорма.ГруппыПользователей", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПароль(Команда)
	
	ТекущиеДанные = Элементы.ПользователиСписок.ТекущиеДанные;
	
	Если СтандартныеПодсистемыКлиент.ЭтоЭлементДинамическогоСписка(ТекущиеДанные) Тогда
		ПользователиСлужебныйКлиент.ОткрытьФормуСменыПароля(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьИЗакрыть(Команда)
	
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		МассивПользователей = РезультатВыбора();
		ОповеститьОВыборе(МассивПользователей);
		СписокВыбранныхПользователейИзменен = Ложь;
		Закрыть(МассивПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователяКоманда(Команда)
	
	МассивПользователей = Элементы.ПользователиСписок.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборПользователяИлиГруппы(Команда)
	
	УдалитьИзСпискаВыбранных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокВыбранныхПользователейИГрупп(Команда)
	
	УдалитьИзСпискаВыбранных(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппу(Команда)
	
	МассивГрупп = Элементы.ГруппыПользователей.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивГрупп);
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОПользователях(Команда)
	
	ОткрытьФорму(
		"Отчет.СведенияОПользователях.ФормаОбъекта",
		Новый Структура("КлючВарианта", "СведенияОПользователях"),
		ЭтотОбъект,
		"СведенияОПользователях");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Поддержка группового изменения объектов.

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
		МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.ПользователиСписок);
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ ГИСМ
// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.ПользователиСписок);
	
КонецПроцедуры
//-- НЕ ГИСМ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьХранимыеПараметры()
	
	ХранимыеПараметры = Новый Структура;
	ХранимыеПараметры.Вставить("ВыборГруппПользователей", Параметры.ВыборГруппПользователей);
	
КонецПроцедуры

&НаСервере
Процедура ОформитьИСкрытьНедействительныхПользователей()
	
	// Оформление.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПользователиСписок.Недействителен");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ПользователиСписок");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Скрытие.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПользователиСписок, "Недействителен", Ложь, , , Истина);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПорядокГруппыВсеПользователи(Список)
	
	Перем Порядок;
	
	// Порядок.
	Порядок = Список.КомпоновщикНастроек.Настройки.Порядок;
	Порядок.ИдентификаторПользовательскойНастройки = "ОсновнойПорядок";
	
	Порядок.Элементы.Очистить();
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыСпискаПользователейДляКомандыУстановитьПароль()
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ИдентификаторТекущегоПользователяИБ",
		ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ПустойУникальныйИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВозможноСменитьТолькоСвойПароль",
		Не Пользователи.ЭтоПолноправныйПользователь());
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаИзмененияТекущегоЭлементаФормы()
	
	Если ТекущийЭлемент.Имя <> ИмяТекущегоЭлемента Тогда
		ПриИзмененииТекущегоЭлементаФормы();
		ИмяТекущегоЭлемента = ТекущийЭлемент.Имя;
	КонецЕсли;
	
#Если ВебКлиент Тогда
	ПодключитьОбработчикОжидания("ПроверкаИзмененияТекущегоЭлементаФормы", 0.7, Истина);
#Иначе
	ПодключитьОбработчикОжидания("ПроверкаИзмененияТекущегоЭлементаФормы", 0.1, Истина);
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииТекущегоЭлементаФормы()
	
	Если ТекущийЭлемент.Имя = "ГруппыПользователей" Тогда
		Элементы.Комментарии.ТекущаяСтраница = Элементы.КомментарийГруппы;
		
	ИначеЕсли ТекущийЭлемент.Имя = "ПользователиСписок" Тогда
		Элементы.Комментарии.ТекущаяСтраница = Элементы.КомментарийПользователя;
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура УдалитьИзСпискаВыбранных(УдалитьВсех = Ложь)
	
	Если УдалитьВсех Тогда
		ВыбранныеПользователиИГруппы.Очистить();
		ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
		Возврат;
	КонецЕсли;
	
	МассивЭлементовСписка = Элементы.СписокВыбранныхПользователейИГрупп.ВыделенныеСтроки;
	Для Каждого ЭлементСписка Из МассивЭлементовСписка Цикл
		ВыбранныеПользователиИГруппы.Удалить(ВыбранныеПользователиИГруппы.НайтиПоИдентификатору(ЭлементСписка));
	КонецЦикла;
	
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивВыбранныхЭлементов)
	
	ВыбранныеЭлементыИКартинки = Новый Массив;
	Для Каждого ВыбранныйЭлемент Из МассивВыбранныхЭлементов Цикл
		
		Если ТипЗнч(ВыбранныйЭлемент) = Тип("СправочникСсылка.Пользователи") Тогда
			НомерКартинки = Элементы.ПользователиСписок.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		Иначе
			НомерКартинки = Элементы.ГруппыПользователей.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		КонецЕсли;
		
		ВыбранныеЭлементыИКартинки.Добавить(
			Новый Структура("ВыбранныйЭлемент, НомерКартинки", ВыбранныйЭлемент, НомерКартинки));
	КонецЦикла;
	
	ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки);
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	
	ВыбранныеПользователиТаблицаЗначений = ВыбранныеПользователиИГруппы.Выгрузить( , "Пользователь");
	МассивПользователей = ВыбранныеПользователиТаблицаЗначений.ВыгрузитьКолонку("Пользователь");
	Возврат МассивПользователей;
	
КонецФункции

&НаСервере
Процедура ИзменитьПараметрыРасширеннойФормыПодбора()
	
	// Загрузка списка выбранных пользователей.
	Если ЗначениеЗаполнено(Параметры.ПараметрыРасширеннойФормыПодбора) Тогда
		ПараметрыРасширеннойФормыПодбора = ПолучитьИзВременногоХранилища(Параметры.ПараметрыРасширеннойФормыПодбора);
	Иначе
		ПараметрыРасширеннойФормыПодбора = Параметры;
	КонецЕсли;
	Если ТипЗнч(ПараметрыРасширеннойФормыПодбора.ВыбранныеПользователи) = Тип("ТаблицаЗначений") Тогда
		ВыбранныеПользователиИГруппы.Загрузить(ПараметрыРасширеннойФормыПодбора.ВыбранныеПользователи);
	Иначе
		Для Каждого ВыбранныйПользователь Из ПараметрыРасширеннойФормыПодбора.ВыбранныеПользователи Цикл
			ВыбранныеПользователиИГруппы.Добавить().Пользователь = ВыбранныйПользователь;
		КонецЦикла;
	КонецЕсли;
	Пользователи.ЗаполнитьНомераКартинокПользователей(ВыбранныеПользователиИГруппы, "Пользователь", "НомерКартинки");
	ХранимыеПараметры.Вставить("ЗаголовокФормыПодбора", ПараметрыРасширеннойФормыПодбора.ЗаголовокФормыПодбора);
	// Установка параметров расширенной формы подбора.
	Элементы.ЗавершитьИЗакрыть.Видимость                      = Истина;
	Элементы.ГруппаВыбратьПользователя.Видимость              = Истина;
	// Включение видимости списка выбранных пользователей.
	Элементы.ВыбранныеПользователиИГруппы.Видимость     = Истина;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") Тогда
		Элементы.ГруппыИПользователи.Группировка                 = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ПользователиСписок.Высота                       = 5;
		Элементы.ГруппыПользователей.Высота                      = 3;
		ЭтотОбъект.Высота                                        = 17;
		Элементы.ГруппаВыбратьГруппу.Видимость                   = Истина;
		// Включение отображения заголовков списков ПользователиСписок и ГруппыПользователей.
		Элементы.ГруппыПользователей.ПоложениеЗаголовка          = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ПользователиСписок.ПоложениеЗаголовка           = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ПользователиСписок.Заголовок                    = НСтр("ru = 'Пользователи в группе'");
		Если ПараметрыРасширеннойФормыПодбора.Свойство("ПодборГруппНевозможен") Тогда
			Элементы.ВыбратьГруппу.Видимость                     = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтменитьВыборПользователя.Видимость             = Истина;
		Элементы.ОчиститьСписокВыбранных.Видимость               = Истина;
	КонецЕсли;
	
	// Добавление количества выбранных пользователей в заголовке выбранных пользователей и групп.
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп()
	
	Если ХранимыеПараметры.ИспользоватьГруппы Тогда
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи и группы (%1)'");
	Иначе
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи (%1)'");
	КонецЕсли;
	
	КоличествоПользователей = ВыбранныеПользователиИГруппы.Количество();
	Если КоличествоПользователей <> 0 Тогда
		Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокВыбранныеПользователиИГруппы, КоличествоПользователей);
	Иначе
		Если ХранимыеПараметры.ИспользоватьГруппы Тогда
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи и группы'");
		Иначе
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки)
	
	Для Каждого СтрокаМассива Из ВыбранныеЭлементыИКартинки Цикл
		
		ВыбранныйПользовательИлиГруппа = СтрокаМассива.ВыбранныйЭлемент;
		НомерКартинки = СтрокаМассива.НомерКартинки;
		
		ПараметрыОтбора = Новый Структура("Пользователь", ВыбранныйПользовательИлиГруппа);
		Найденный = ВыбранныеПользователиИГруппы.НайтиСтроки(ПараметрыОтбора);
		Если Найденный.Количество() = 0 Тогда
			
			СтрокаВыбранныеПользователи = ВыбранныеПользователиИГруппы.Добавить();
			СтрокаВыбранныеПользователи.Пользователь = ВыбранныйПользовательИлиГруппа;
			СтрокаВыбранныеПользователи.НомерКартинки = НомерКартинки;
			СписокВыбранныхПользователейИзменен = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВыбранныеПользователиИГруппы.Сортировать("Пользователь Возр");
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияГруппПользователей()
	
	НастроитьФормуПоИспользованиюГруппПользователей(Истина);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоИспользованиюГруппПользователей(ИзменилосьИспользованиеГрупп = Ложь)
	
	Если ИзменилосьИспользованиеГрупп Тогда
		ХранимыеПараметры.Вставить("ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));
	КонецЕсли;
	
	Если ХранимыеПараметры.Свойство("ТекущаяСтрока") Тогда
		
		Если ТипЗнч(ХранимыеПараметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
			
			Если ХранимыеПараметры.ИспользоватьГруппы Тогда
				Элементы.ГруппыПользователей.ТекущаяСтрока = ХранимыеПараметры.ТекущаяСтрока;
			Иначе
				Параметры.ТекущаяСтрока = Неопределено;
			КонецЕсли;
		Иначе
			ТекущийЭлемент = Элементы.ПользователиСписок;
			Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи;
		КонецЕсли;
	Иначе
		Если НЕ ХранимыеПараметры.ИспользоватьГруппы
		   И Элементы.ГруппыПользователей.ТекущаяСтрока
		     <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			
			Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ВыбиратьИерархически.Видимость = ХранимыеПараметры.ИспользоватьГруппы;
	
	Если Не Пользователи.РолиДоступны("ДобавлениеИзменениеПользователей")
	 Или ХранимыеПараметры.РасширенныйПодбор
	 Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.НазначитьГруппы.Видимость = Ложь;
		Элементы.ПользователиСписокКонтекстноеМенюНазначитьГруппы.Видимость = Ложь;
	Иначе
		Элементы.НазначитьГруппы.Видимость                                  = ХранимыеПараметры.ИспользоватьГруппы;
		Элементы.ПользователиСписокКонтекстноеМенюНазначитьГруппы.Видимость = ХранимыеПараметры.ИспользоватьГруппы;
	КонецЕсли;
	
	Элементы.СоздатьГруппуПользователей.Видимость =
		ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыПользователей)
		И ХранимыеПараметры.ИспользоватьГруппы
		И Не ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто();
	
	ВыборГруппПользователей = ХранимыеПараметры.ВыборГруппПользователей
	                        И ХранимыеПараметры.ИспользоватьГруппы
	                        И Параметры.РежимВыбора;
	
	Если Параметры.РежимВыбора Тогда
		
		Элементы.ВыбратьГруппуПользователей.Видимость  = 
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, ВыборГруппПользователей);
		Элементы.ВыбратьПользователя.КнопкаПоУмолчанию =
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, Не ВыборГруппПользователей);
		Элементы.ВыбратьПользователя.Видимость         = Не ХранимыеПараметры.РасширенныйПодбор;
		АвтоЗаголовок = Ложь;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			
			Если ВыборГруппПользователей Тогда
				
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор пользователей и групп'");
				КонецЕсли;
				
				Элементы.ВыбратьПользователя.Заголовок =
					НСтр("ru = 'Выбрать пользователей'");
				
				Элементы.ВыбратьГруппуПользователей.Заголовок =
					НСтр("ru = 'Выбрать группы'");
			Иначе
				
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор пользователей'");
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			// Режим выбора.
			Если ВыборГруппПользователей Тогда
				
				Заголовок = НСтр("ru = 'Выбор пользователя или группы'");
				
				Элементы.ВыбратьПользователя.Заголовок = НСтр("ru = 'Выбрать пользователя'");
			Иначе
				Заголовок = НСтр("ru = 'Выбор пользователя'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
	// Принудительное обновление видимости после изменения функциональной
	// опции без использования команды ОбновитьИнтерфейс.
	Элементы.ГруппыПользователей.Видимость = Ложь;
	Элементы.ГруппыПользователей.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПослеАктивизацииСтроки()
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВНовуюГруппу(МассивПользователей, НоваяГруппаВладелец, Перемещение)
	
	Если НоваяГруппаВладелец = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекущаяГруппаВладелец = Элементы.ГруппыПользователей.ТекущаяСтрока;
	СообщениеПользователю = ПользователиСлужебный.ПеремещениеПользователяВНовуюГруппу(
		МассивПользователей, ТекущаяГруппаВладелец, НоваяГруппаВладелец, Перемещение);
	
	Элементы.ПользователиСписок.Обновить();
	Элементы.ГруппыПользователей.Обновить();
	
	Возврат СообщениеПользователю;
	
КонецФункции

&НаКлиенте
Процедура ГруппыПользователейПеретаскиваниеЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СообщениеПользователю = ПеремещениеПользователяВНовуюГруппу(
		ДополнительныеПараметры.ПараметрыПеретаскивания,
		ДополнительныеПараметры.Строка,
		ДополнительныеПараметры.Перемещение);
	
	Если СообщениеПользователю.Сообщение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СообщениеПользователю.ЕстьОшибки = Ложь Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю.Сообщение, БиблиотекаКартинок.Информация32);
	Иначе
		ПоказатьПредупреждение(,СообщениеПользователю.Сообщение);
	КонецЕсли;
	
	Оповестить("Запись_ГруппыВнешнихПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьОтображениеНедействительныхПользователей(ПоказатьНедействительных)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПользователиСписок, "Недействителен", Ложь, , ,
		НЕ ПоказатьНедействительных);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы(Форма)
	
	Элементы = Форма.Элементы;
	ГруппаВсеПользователи = ПредопределенноеЗначение(
		"Справочник.ГруппыПользователей.ВсеПользователи");
	
	Если НЕ Форма.ХранимыеПараметры.ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыПользователей.ТекущаяСтрока = ГруппаВсеПользователи Тогда
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ПользователиСписок,
			"ВсеПользователи", Истина);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ПользователиСписок,
			"ВыбиратьИерархически", Ложь);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ПользователиСписок,
			"ГруппаПользователей", ГруппаВсеПользователи);
	Иначе
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ПользователиСписок,
			"ВсеПользователи", Ложь);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ПользователиСписок,
			"ВыбиратьИерархически", Форма.ВыбиратьИерархически);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ПользователиСписок,
			"ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров,
                                                    Знач ИмяПараметра,
                                                    Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			
			Если Параметр.Использование
			   И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

#КонецОбласти
