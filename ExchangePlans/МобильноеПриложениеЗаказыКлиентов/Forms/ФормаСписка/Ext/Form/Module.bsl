﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = Нстр("ru = 'Мобильные устройства с установленным мобильным приложением ""1С:Заказы""'");
	
	УстановитьПараметрыДинамическогоСписка();
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

&НаКлиенте
Процедура ПользовательФильтрПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Пользователь", Пользователь,
		ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Пользователь));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Если НЕ ТипЗнч(ВыбраннаяСтрока.Ключ) = Тип("Строка") Тогда
			ПоказатьЗначение(, ВыбраннаяСтрока.Ключ);
		КонецЕсли;
	Иначе
		ПоказатьЗначение(, ВыбраннаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СписокПриАктивизацииСтрокиНаСервере(ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыПометкиУдаления = Новый Структура;
	Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ПометкаНаУдаление = ЭлементСпискаПомеченНаУдаление(ТекущаяСтрока.Ключ);
		Если НЕ ПометкаНаУдаление Тогда
			ТекстВопроса = НСтр("ru = 'Если пометить на удаление настройку синхронизации,
			|то на мобильном устройстве будут удалены все данные приложения 1С:Заказы при следующем сеансе обмена.
			|Пометить на удаление все настройки из группы ""%ГруппаНастроек%""?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Снять пометку на удаление со всех настроек из группы ""%ГруппаНастроек%""?'");
		КонецЕсли;
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ГруппаНастроек%", ТекущаяСтрока.Ключ);
		ПараметрыПометкиУдаления.Вставить("УзелОбмена", ТекущаяСтрока.Ключ);
		ПараметрыПометкиУдаления.Вставить("ЭтоГруппа", Истина);
		ПараметрыПометкиУдаления.Вставить("ПометкаУдаления", ПометкаНаУдаление);
	ИначеЕсли ТипЗнч(ТекущаяСтрока) = Тип("ПланОбменаСсылка.МобильноеПриложениеЗаказыКлиентов") Тогда
		Если ТекущиеДанные.ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru = 'Снять пометку на удаление с настройки ""%Настройка%""?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Если пометить на удаление настройку синхронизации,
			|то на мобильном устройстве будут удалены все данные приложения 1С:Заказы при следующем сеансе обмена.
			|Пометить на удаление настройку ""%Настройка%""?'");
		КонецЕсли;
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Настройка%", ТекущаяСтрока);
		ПараметрыПометкиУдаления.Вставить("УзелОбмена", ТекущаяСтрока);
		ПараметрыПометкиУдаления.Вставить("ПометкаУдаления", ТекущиеДанные.ПометкаУдаления);
	КонецЕсли;
	ЗаголовокВопроса = НСтр("ru = 'Настройки синхронизации'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтветаНаВопросПометкаУдаления", ЭтаФорма, ПараметрыПометкиУдаления);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, ЗаголовокВопроса);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНастройку(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Если НЕ ТипЗнч(ТекущаяСтрока.Ключ) = Тип("Строка") И ЗначениеЗаполнено(ТекущаяСтрока.Ключ) Тогда
			ПараметрыФормы.Вставить("ВидНастройкиОбмена", ТекущаяСтрока.Ключ);
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ПараметрыФормы.Вставить("Пользователь", Пользователь);
	КонецЕсли;
	ОткрытьФорму("ПланОбмена.МобильноеПриложениеЗаказыКлиентов.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНастройкуКонтекст(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Если ТипЗнч(ТекущаяСтрока.Ключ) = Тип("Строка") Тогда
			Если ЗначениеЗаполнено(Пользователь) Тогда
				ПараметрыФормы.Вставить("Пользователь", Пользователь);
			КонецЕсли;
		Иначе
			СкопироватьУзелОбмена(ТекущаяСтрока.Ключ, ПараметрыФормы);
		КонецЕсли;
	ИначеЕсли ТипЗнч(ТекущаяСтрока) = Тип("ПланОбменаСсылка.МобильноеПриложениеЗаказыКлиентов") Тогда
		СкопироватьУзелОбмена(ТекущаяСтрока, ПараметрыФормы);
	КонецЕсли;
	ОткрытьФорму("ПланОбмена.МобильноеПриложениеЗаказыКлиентов.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПометитьНаУдалениеНастройки(УзелОбмена, ПометкаУдаления)
	
	ПометитьНаУдалениеНастройку(УзелОбмена, ПометкаУдаления);
	
	НастройкиВГруппе = ПланыОбмена.МобильноеПриложениеЗаказыКлиентов.Выбрать(Новый Структура("ВидНастройкиОбмена", УзелОбмена));
	Пока НастройкиВГруппе.Следующий() Цикл
		ПометитьНаУдалениеНастройку(НастройкиВГруппе.Ссылка, ПометкаУдаления);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеНастройку(УзелОбмена, ПометкаУдаления)
	
	УзелОбъект = УзелОбмена.ПолучитьОбъект();
	УзелОбъект.ПометкаУдаления = ПометкаУдаления;
	Попытка
		УзелОбъект.Записать();
	Исключение
		ВызватьИсключение(ОписаниеОшибки());
	КонецПопытки
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросПометкаУдаления(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Свойство("ЭтоГруппа") Тогда
		ПометитьНаУдалениеНастройки(ДополнительныеПараметры.УзелОбмена, НЕ ДополнительныеПараметры.ПометкаУдаления);
	Иначе
		ПометитьНаУдалениеНастройку(ДополнительныеПараметры.УзелОбмена, НЕ ДополнительныеПараметры.ПометкаУдаления);
	КонецЕсли;
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура СкопироватьУзелОбмена(Узел, ПараметрыФормы)
	
	РеквизитыУзла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Узел, "ВидНастройкиОбмена, Пользователь, НастройкиОбмена");
	ПараметрыФормы.Вставить("Пользователь", РеквизитыУзла.Пользователь);
	ПараметрыФормы.Вставить("ВидНастройкиОбмена", РеквизитыУзла.ВидНастройкиОбмена);
	ПараметрыФормы.Вставить("НастройкиОбмена", РеквизитыУзла.НастройкиОбмена);
КонецПроцедуры

&НаСервере
Процедура СписокПриАктивизацииСтрокиНаСервере(ТекущаяСтрока)
	
	ВидимостьКомандыУдалить = Истина;
	КартинкаКоманды = БиблиотекаКартинок.СкопироватьЭлементСписка;
	Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Если ТипЗнч(ТекущаяСтрока.Ключ) = Тип("Строка") Тогда
			ЗаголовокКоманды = НСтр("ru = 'Создать настройку'");
			ВидимостьКомандыУдалить = Ложь;
			КартинкаКоманды = БиблиотекаКартинок.СоздатьЭлементСписка;
		Иначе
			ЗаголовокКоманды = НСтр("ru = 'Скопировать настройку'");
			ПометкаНаУдаление = ЭлементСпискаПомеченНаУдаление(ТекущаяСтрока.Ключ);
			Если ПометкаНаУдаление Тогда
				ЗаголовокКомандыУдалить = НСтр("ru = 'Снять пометку со всех настроек из группы'");
			Иначе
				ЗаголовокКомандыУдалить = НСтр("ru = 'Пометить на удаление все настройки из группы'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		ЗаголовокКоманды = НСтр("ru = 'Скопировать настройку'");
		ПометкаНаУдаление = ЭлементСпискаПомеченНаУдаление(ТекущаяСтрока);
		Если ПометкаНаУдаление Тогда
			ЗаголовокКомандыУдалить = НСтр("ru = 'Снять пометку'");
		Иначе
			ЗаголовокКомандыУдалить = НСтр("ru = 'Пометить на удаление'");
		КонецЕсли;
	КонецЕсли;
	Элементы.СписокКонтекстноеМенюСоздатьНастройку.Заголовок = ЗаголовокКоманды;
	Элементы.СписокКонтекстноеМенюСоздатьНастройку.Картинка = КартинкаКоманды;
	Элементы.СписокКонтекстноеМенюПометитьНаУдаление.Видимость = ВидимостьКомандыУдалить;
	Элементы.СписокКонтекстноеМенюПометитьНаУдаление.Заголовок = ЗаголовокКомандыУдалить;
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "РегистрСведений.СостоянияОбменовДанными",
			"РегистрСведений.СостоянияОбменовДаннымиОбластейДанных");
	КонецЕсли;
		
	Если Параметры.Свойство("НеОтображатьЭтотУзел") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("НеОтображатьЭтотУзел", Параметры.НеОтображатьЭтотУзел);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("НеОтображатьЭтотУзел", Ложь);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ПустаяНастройка", НСтр("ru = 'Индивидуальные настройки'"));
КонецПроцедуры

&НаСервере
Функция ЭлементСпискаПомеченНаУдаление(ЭлементСписка)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементСписка, "ПометкаУдаления");
КонецФункции

#КонецОбласти
