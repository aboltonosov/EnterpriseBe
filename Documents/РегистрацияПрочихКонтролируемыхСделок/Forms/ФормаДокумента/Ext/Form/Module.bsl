﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

	УстановитьУсловноеОформление();

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Для Каждого СтрокаСделки Из Объект.Сделки Цикл
		РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УведомлениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.УведомлениеОКонтролируемойСделке) Тогда
		ЗаполнитьЗначенияСвойств(Объект, ПриИзмененииУведомленияНаСервере(Объект.УведомлениеОКонтролируемойСделке));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ИзменениеДоговораСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСделки

&НаКлиенте
Процедура СделкиДатаСовершенияСделкиПриИзменении(Элемент)
	
	Если Объект.ВалютаДокумента <> ВалютаРегламентированногоУчета Тогда
		СтрокаСделки = Элементы.Сделки.ТекущиеДанные;
		ДанныеОбменаССервером = Новый Структура("ДатаСовершенияСделки, ДоговорКонтрагента, СуммаБезНДСВРублях, СуммаБезНДСВВалютеРасчетов,
			|СуммаНДСВРублях, СуммаНДСВВалютеРасчетов, СтавкаНДС, ВалютаДокумента");
		ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, СтрокаСделки);
		ДанныеОбменаССервером.ВалютаДокумента = Объект.ВалютаДокумента;
		ПересчитатьСуммыСтроки(ДанныеОбменаССервером, "ДатаСовершенияСделки");
		ЗаполнитьЗначенияСвойств(СтрокаСделки, ДанныеОбменаССервером);
		РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СделкиСуммаБезНДСВРубляхПриИзменении(Элемент)
	
	СтрокаСделки = Элементы.Сделки.ТекущиеДанные;
	ДанныеОбменаССервером = Новый Структура("СуммаБезНДСВРублях, СуммаНДСВРублях, СтавкаНДС");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, СтрокаСделки);
	ПересчитатьСуммыСтроки(ДанныеОбменаССервером, "СуммаБезНДСВРублях");
	ЗаполнитьЗначенияСвойств(СтрокаСделки, ДанныеОбменаССервером);
	РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);

КонецПроцедуры

&НаКлиенте
Процедура СделкиСуммаБезНДСВВалютеРасчетовПриИзменении(Элемент)
	
	СтрокаСделки = Элементы.Сделки.ТекущиеДанные;
	ДанныеОбменаССервером = Новый Структура("ДоговорКонтрагента, ДатаСовершенияСделки,
		|СуммаБезНДСВРублях, СуммаБезНДСВВалютеРасчетов, СуммаНДСВРублях, СуммаНДСВВалютеРасчетов, СтавкаНДС, ВалютаДокумента");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, СтрокаСделки);
	ДанныеОбменаССервером.ВалютаДокумента = Объект.ВалютаДокумента;
	ПересчитатьСуммыСтроки(ДанныеОбменаССервером, "СуммаБезНДСВВалютеРасчетов");
	ЗаполнитьЗначенияСвойств(СтрокаСделки, ДанныеОбменаССервером);
	РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);

КонецПроцедуры

&НаКлиенте
Процедура СделкиСтавкаНДСПриИзменении(Элемент)
	
	СтрокаСделки = Элементы.Сделки.ТекущиеДанные;
	ДанныеОбменаССервером = Новый Структура("ДатаСовершенияСделки,
		|СуммаБезНДСВРублях, СуммаБезНДСВВалютеРасчетов, СуммаНДСВРублях, СуммаНДСВВалютеРасчетов, СтавкаНДС, ВалютаДокумента");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, СтрокаСделки);
	ДанныеОбменаССервером.ВалютаДокумента = Объект.ВалютаДокумента;
	ПересчитатьСуммыСтроки(ДанныеОбменаССервером, "СтавкаНДС");
	ЗаполнитьЗначенияСвойств(СтрокаСделки, ДанныеОбменаССервером);
	РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);

КонецПроцедуры

&НаКлиенте
Процедура СделкиСуммаНДСВРубляхПриИзменении(Элемент)
	
	СтрокаСделки = Элементы.Сделки.ТекущиеДанные;
	РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);
	
КонецПроцедуры

&НаКлиенте
Процедура СделкиСуммаНДСВВалютеРасчетовПриИзменении(Элемент)
	
	СтрокаСделки = Элементы.Сделки.ТекущиеДанные;
	РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);

КонецПроцедуры

&НаКлиенте
Процедура СделкиПредметСделкиПриИзменении(Элемент)
	
	СтрокаСделки = Элементы.Сделки.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаСделки.ПредметСделки) Тогда
		ДанныеОбменаССервером = Новый Структура("ПредметСделки");
		ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, СтрокаСделки);
		ЗаполнитьЗначенияСвойств(СтрокаСделки, ИзменениеПредметаСделкиСервер(ДанныеОбменаССервером));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();


	// СделкиСуммаБезНДСВВалютеРасчетов, СделкиСуммаНДСВВалютеРасчетов, СделкиВсегоВВалютеРасчетов.

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("СделкиСуммаБезНДСВВалютеРасчетов");
	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("СделкиСуммаНДСВВалютеРасчетов");
	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("СделкиВсегоВВалютеРасчетов");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ВалютаДокумента", ВидСравненияКомпоновкиДанных.Равно, Новый ПолеКомпоновкиДанных("ВалютаРегламентированногоУчета"));

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// СделкиГрузоотправитель

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("СделкиГрузоотправитель");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Сделки.ТипПредметаСделки", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.ТипыПредметовКонтролируемыхСделок.Товар);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не требуется>'"));

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);


	// СделкиСтранаПроисхожденияПредметаСделки

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("СделкиСтранаПроисхожденияПредметаСделки");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Сделки.ТипПредметаСделки", ВидСравненияКомпоновкиДанных.Равно, Перечисления.ТипыПредметовКонтролируемыхСделок.РаботаУслуга);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не требуется>'"));

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Для Каждого СтрокаСделки Из Объект.Сделки Цикл
		РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, СтрокаСделки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеДоговораСервер()
	
	ВалютаВзаиморасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДоговорКонтрагента, "ВалютаВзаиморасчетов");
	Если ВалютаВзаиморасчетов <> Объект.ВалютаДокумента Тогда
		Объект.ВалютаДокумента = ВалютаВзаиморасчетов;
		Для Каждого Сделка ИЗ Объект.Сделки Цикл
			СтруктураКурсаДокумента = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Сделка.ДатаСовершенияСделки);
			Сделка.СуммаБезНДСВРублях = Сделка.СуммаБезНДСВВалютеРасчетов 
				* СтруктураКурсаДокумента.Курс / ?(СтруктураКурсаДокумента.Кратность = 0, 1, СтруктураКурсаДокумента.Кратность);
			Сделка.СуммаНДСВРублях = УчетНДСКлиентСервер.РассчитатьСуммуНДС(Сделка.СуммаБезНДСВРублях, Ложь,
														УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Сделка.СтавкаНДС));
			РасчитатьЗначенияДополнительныхКолонок(ЭтаФорма, Сделка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменениеПредметаСделкиСервер(ДанныеДляЗаполнения)
	
	ИзмененныеДанные = Новый Структура();
	
	Если ТипЗнч(ДанныеДляЗаполнения.ПредметСделки) = Тип("СправочникСсылка.Номенклатура") Тогда
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеДляЗаполнения.ПредметСделки, 
			"НаименованиеПолное, ТипНоменклатуры, ЕдиницаИзмерения");
		ИзмененныеДанные.Вставить("НаименованиеПредметаСделки", РеквизитыНоменклатуры.НаименованиеПолное);
		ИзмененныеДанные.Вставить("ТипПредметаСделки", ?(РеквизитыНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа
														ИЛИ РеквизитыНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга, 
														Перечисления.ТипыПредметовКонтролируемыхСделок.РаботаУслуга, 
														Перечисления.ТипыПредметовКонтролируемыхСделок.Товар));
		ИзмененныеДанные.Вставить("ЕдиницаИзмерения", РеквизитыНоменклатуры.ЕдиницаИзмерения);
	ИначеЕсли ДанныеДляЗаполнения.ПредметСделки <> Неопределено Тогда
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеДляЗаполнения.ПредметСделки, 
			"Наименование");
		ИзмененныеДанные.Вставить("НаименованиеПредметаСделки", РеквизитыНоменклатуры.Наименование);
		ИзмененныеДанные.Вставить("ТипПредметаСделки", Перечисления.ТипыПредметовКонтролируемыхСделок.ИнойОбъектГражданскихПрав);
	КонецЕсли;
		
	Возврат ИзмененныеДанные;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РасчитатьЗначенияДополнительныхКолонок(Форма, СтрокаСделки)
	
	СтрокаСделки.ВсегоВРублях = СтрокаСделки.СуммаБезНДСВРублях + СтрокаСделки.СуммаНДСВРублях;
	СтрокаСделки.ВсегоВВалютеРасчетов = СтрокаСделки.СуммаБезНДСВВалютеРасчетов + СтрокаСделки.СуммаНДСВВалютеРасчетов;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РассчитатьСуммуНДС(СуммаБезНДС, СтавкаНДС)
	
	Возврат УчетНДСКлиентСервер.РассчитатьСуммуНДС(СуммаБезНДС, Ложь, УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтавкаНДС));
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПересчитатьСуммыСтроки(ДанныеСтроки, ИзмененноеПоле)
	
	Если ИзмененноеПоле = "ДатаСовершенияСделки" Тогда
		СтруктураКурсаДокумента = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДанныеСтроки.ВалютаДокумента, ДанныеСтроки.ДатаСовершенияСделки);
		ДанныеСтроки.СуммаБезНДСВРублях = ДанныеСтроки.СуммаБезНДСВВалютеРасчетов 
			* СтруктураКурсаДокумента.Курс / ?(СтруктураКурсаДокумента.Кратность = 0, 1, СтруктураКурсаДокумента.Кратность);
		ПересчитатьСуммыСтроки(ДанныеСтроки, "СуммаБезНДСВРублях");
	ИначеЕсли ИзмененноеПоле = "СуммаБезНДСВРублях" Тогда
		ДанныеСтроки.СуммаНДСВРублях = РассчитатьСуммуНДС(ДанныеСтроки.СуммаБезНДСВРублях, ДанныеСтроки.СтавкаНДС);
	ИначеЕсли ИзмененноеПоле = "СуммаБезНДСВВалютеРасчетов" Тогда
		СтруктураКурсаДокумента = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДанныеСтроки.ВалютаДокумента, ДанныеСтроки.ДатаСовершенияСделки);
		ДанныеСтроки.СуммаНДСВВалютеРасчетов = РассчитатьСуммуНДС(ДанныеСтроки.СуммаБезНДСВВалютеРасчетов, ДанныеСтроки.СтавкаНДС);
		ДанныеСтроки.СуммаБезНДСВРублях = ДанныеСтроки.СуммаБезНДСВВалютеРасчетов 
			* СтруктураКурсаДокумента.Курс / ?(СтруктураКурсаДокумента.Кратность = 0, 1, СтруктураКурсаДокумента.Кратность);
		ПересчитатьСуммыСтроки(ДанныеСтроки, "СуммаБезНДСВРублях");
	ИначеЕсли ИзмененноеПоле = "СтавкаНДС" Тогда
		ДанныеСтроки.СуммаНДСВВалютеРасчетов = РассчитатьСуммуНДС(ДанныеСтроки.СуммаБезНДСВВалютеРасчетов, ДанныеСтроки.СтавкаНДС);
		ДанныеСтроки.СуммаНДСВРублях = РассчитатьСуммуНДС(ДанныеСтроки.СуммаБезНДСВРублях, ДанныеСтроки.СтавкаНДС);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПриИзмененииУведомленияНаСервере(Уведомление) 
	
	Если ЗначениеЗаполнено(Уведомление) Тогда 
		Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Уведомление, "Организация, Дата");
	Иначе
		Возврат Новый Структура("Организация", Неопределено);
	КонецЕсли;

КонецФункции

#КонецОбласти