﻿
&НаКлиенте
Перем КэшированныеЗначения; // используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;

	ЗапасыСервер.УстановитьВидимостьТиповПредназначенийВидовЗапасов(ЭтаФорма, Элементы.Предназначение);
	ЗапасыСервер.УстановитьВидимостьТиповПредназначенийВидовЗапасов(ЭтаФорма, Элементы.НовоеПредназначение);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Документ.КорректировкаОбособленногоУчетаЗапасов.Форма.ПодборПоОстаткам" Тогда
		
		ЗаполнитьДокументРезультатомПодбора(ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов" Тогда	
		
		ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение);
		Объект.ВидыЗапасовУказаныВручную = ИсточникВыбора.ВидыЗапасовУказаныВручную;
		Модифицированность = Истина;
		
	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Товары,
		ПараметрыЗаполненияРеквизитов);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПредназначениеПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура НовоеПредназначениеПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);

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


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЗапасов(Команда)
	
	Перем АдресТоваровВХранилище;
	Перем АдресВидовЗапасовВХранилище;
	
	ПоместитьТоварыИВидыЗапасовВХранилище(
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище);
	ФинансыКлиент.ОткрытьВидыЗапасов(
		Объект,
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткамТоваровОрганизаций(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Склад");
	СтруктураРеквизитов.Вставить("Предназначение");
	
	Оповещение = Новый ОписаниеОповещения("ПодборПоОстаткамТоваровОрганизацийЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма,
		Неопределено,
		СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткамТоваровОрганизацийЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	АдресПлатежейВХранилище = ПоместитьТоварыВХранилище(
		Объект.Товары,
		УникальныйИдентификатор);
	ПараметрыПодбора = Новый Структура("АдресПлатежейВХранилище, Организация, Склад",
		АдресПлатежейВХранилище,
		Объект.Организация, 
		Объект.Склад);
	ПараметрыПодбора.Вставить("Предназначение", Объект.Предназначение);
	ПараметрыПодбора.Вставить("Менеджер", Объект.Менеджер);
	ПараметрыПодбора.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыПодбора.Вставить("Сделка", Объект.Сделка);
	ОткрытьФорму(
		"Документ.КорректировкаОбособленногоУчетаЗапасов.Форма.ПодборПоОстаткам",
		ПараметрыПодбора, 
		ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");

КонецПроцедуры

#Область ПодборыИОбработкаПроверкиКоличества

&НаСервере
Функция ПоместитьТоварыВХранилище(Знач Товары, УникальныйИдентификатор)

	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(
		Товары.Выгрузить(,"Номенклатура, Характеристика, Серия, Количество"),
		УникальныйИдентификатор);
		
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

&НаСервере
Процедура ПоместитьТоварыИВидыЗапасовВХранилище(АдресТоваровВХранилище, АдресВидовЗапасовВХранилище)
	
	ЗапасыСервер.ПоместитьТоварыИВидыЗапасовВХранилище(
		Объект.Товары,
		Объект.ВидыЗапасов,
		УникальныйИдентификатор,
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище);
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьВидыЗапасовИзХранилища(АдресВидовЗапасовВХранилище)
	
	Объект.ВидыЗапасов.Загрузить(ПолучитьИзВременногоХранилища(АдресВидовЗапасовВХранилище));
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресПлатежейВХранилище)
	
	Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Товары,
		ПараметрыЗаполненияРеквизитов);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументРезультатомПодбора(РезультатВыбора)

	ПолучитьТоварыИзХранилища(РезультатВыбора.АдресПлатежейВХранилище);
	
	Объект.Предназначение = РезультатВыбора.Предназначение;
	Объект.Подразделение = РезультатВыбора.Подразделение;
	Объект.Менеджер = РезультатВыбора.Менеджер;
	Объект.Сделка = РезультатВыбора.Сделка;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "")
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст)Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УправлениеЭлементамиФормы();
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Товары,
		ПараметрыЗаполненияРеквизитов);
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект,
																									Документы.КорректировкаОбособленногоУчетаЗапасов));
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если Объект.Предназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки Тогда
		Элементы.СтраницыИсходныеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаСделка;
		
	ИначеЕсли Объект.Предназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера Тогда
		Элементы.СтраницыИсходныеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаМенеджер;
		
	ИначеЕсли Объект.Предназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения Тогда
		Элементы.СтраницыИсходныеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаПодразделение;
		
	Иначе
		Элементы.СтраницыИсходныеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаНеОграничена;
		
	КонецЕсли;
	
	Если Объект.НовоеПредназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки Тогда
		Элементы.СтраницыНовыеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаНоваяСделка;
		
	ИначеЕсли Объект.НовоеПредназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера Тогда
		Элементы.СтраницыНовыеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаНовыйМенеджер;
		
	ИначеЕсли Объект.НовоеПредназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения Тогда
		Элементы.СтраницыНовыеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаНовоеПодразделение;
		
	Иначе
		Элементы.СтраницыНовыеВидыЗапасов.ТекущаяСтраница = Элементы.СтраницаНоваяНеОграничена;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект,
																									Документы.КорректировкаОбособленногоУчетаЗапасов));
		
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
