﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодичностьРодителя = ?(ЗначениеЗаполнено(Объект.Родитель), Объект.Родитель.Периодичность, Объект.Владелец.Периодичность);
	
	Если не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Не ЗначениеЗаполнено(Объект.Периодичность) Тогда
			Если Не ЗначениеЗаполнено(Объект.Родитель) Тогда
				Объект.Периодичность = Перечисления.Периодичность.Год;
			Иначе
				Объект.Периодичность = ПериодичностьРодителя;
			КонецЕсли;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.ПорядокВыполненияЭтапов) Тогда
			Объект.ПорядокВыполненияЭтапов = Перечисления.ПорядокВыполненияЭтаповПодготовкиБюджетов.Последовательно;
		КонецЕсли;
	КонецЕсли;
	
	Периодическая = Объект.Периодичность <> ПериодичностьРодителя;
	УстановитьПараметрыПериодичности();
	УстановитьЗаголовкиЭлементовФормы(Объект, Элементы);

	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	Элементы.Периодическая.ТолькоПросмотр = Элементы.Периодичность.ТолькоПросмотр;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПорядокВыполненияШаговПриИзменении(Элемент)
	
	УстановитьЗаголовкиЭлементовФормы(Объект, Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура УсловиеЗапускаПриИзменении(Элемент)
	
	УстановитьЗаголовкиЭлементовФормы(Объект, Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодическаяПриИзменении(Элемент)
	
	УстановитьПараметрыПериодичности();
	
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	УстановитьПараметрыПериодичности();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеОРазблокировке(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Периодическая.ТолькоПросмотр = Элементы.Периодичность.ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма,,Новый ОписаниеОповещения("ОповещениеОРазблокировке", ЭтаФорма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиЭлементовФормы(Объект, Элементы)
	
	Если Объект.ПорядокВыполненияЭтапов = ПредопределенноеЗначение("Перечисление.ПорядокВыполненияЭтаповПодготовкиБюджетов.Параллельно") Тогда
		Элементы.УсловиеЗапуска.Заголовок = НСтр("ru = 'Запускать все задачи'");
	Иначе
		Элементы.УсловиеЗапуска.Заголовок = НСтр("ru = 'Запускать первую задачу'");
	КонецЕсли;
	
	Если Объект.УсловиеЗапуска = ПредопределенноеЗначение("Перечисление.ТипыУсловийЗапускаЭтаповПодготовкиБюджетов.ДоНачалаПериода")
		ИЛИ Объект.УсловиеЗапуска = ПредопределенноеЗначение("Перечисление.ТипыУсловийЗапускаЭтаповПодготовкиБюджетов.ДоОкончанияПериода") Тогда
		Элементы.Срок.Заголовок = НСтр("ru = 'за'");
	Иначе
		Элементы.Срок.Заголовок = НСтр("ru = 'через'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыПериодичности()
	
	Элементы.Периодичность.Доступность = Периодическая;
	ПериодичностьРодителя = ?(ЗначениеЗаполнено(Объект.Родитель), Объект.Родитель.Периодичность, Объект.Владелец.Периодичность);
	
	Если Периодическая Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ТаблицаПериодичностей.Периодичность,
		               |	ТаблицаПериодичностей.Порядок
		               |ПОМЕСТИТЬ УпорядоченныеПериодичности
		               |ИЗ
		               |	&ТаблицаПериодичностей КАК ТаблицаПериодичностей
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	УпорядоченныеПериодичности.Порядок
		               |ПОМЕСТИТЬ ПериодичностьТекущая
		               |ИЗ
		               |	УпорядоченныеПериодичности КАК УпорядоченныеПериодичности
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Перечисление.Периодичность КАК ПеречислениеПериодичность
		               |		ПО УпорядоченныеПериодичности.Периодичность = ПеречислениеПериодичность.Ссылка
		               |			И (ПеречислениеПериодичность.Ссылка = &Ссылка)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	УпорядоченныеПериодичности.Периодичность КАК Периодичность
		               |ИЗ
		               |	ПериодичностьТекущая КАК ТаблицаПериодичности
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ УпорядоченныеПериодичности КАК УпорядоченныеПериодичности
		               |		ПО ТаблицаПериодичности.Порядок > УпорядоченныеПериодичности.Порядок
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Перечисление.Периодичность КАК ПеречислениеПериодичность
		               |		ПО (УпорядоченныеПериодичности.Периодичность = ПеречислениеПериодичность.Ссылка)";
		
		ТаблицаПериодичностей = Перечисления.Периодичность.УпорядоченныеПериодичности(Истина);
		Запрос.УстановитьПараметр("ТаблицаПериодичностей", ТаблицаПериодичностей);
		Запрос.УстановитьПараметр("Ссылка", ПериодичностьРодителя);
		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Элементы.Периодичность.СписокВыбора.Очистить();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Элементы.Периодичность.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Периодичность);
			
		КонецЦикла;
		
	Иначе
		
		Объект.Периодичность = ПериодичностьРодителя;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

#КонецОбласти
