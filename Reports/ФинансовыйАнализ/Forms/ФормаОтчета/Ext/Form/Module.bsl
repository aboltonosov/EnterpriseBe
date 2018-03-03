﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;
&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;
&НаКлиенте
Перем УИДЗамера;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаАктуальности  = ОбщегоНазначения.ТекущаяДатаПользователя();
	Отчет.Период      = КонецМесяца(ДобавитьМесяц(ДатаАктуальности, -1));
	Отчет.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Главное");
	УстановитьСостояниеПолейТабличныхДокументов(ЭтотОбъект, "НеАктуальность");
	АдресХранилищаДанныеФинансовогоАнализа = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	БухгалтерскийУчетКлиентПереопределяемый.ОбработкаОповещенияАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.Период, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	УстановитьСостояниеПолейТабличныхДокументов(ЭтотОбъект, "НеАктуальность");
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)

	УстановитьВыбранныйПериод();

КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("НачалоПериода, КонецПериода", Отчет.Период, Отчет.Период);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму(
		"ОбщаяФорма.ВыборСтандартногоПериодаМесяц",
		ПараметрыФормы, 
		ЭтотОбъект,
		,
		,
		,
		ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделГлавноеНажатие(Элемент)
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Главное");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделБухгалтерскаяОтчетностьНажатие(Элемент)
	УстановитьСвойстваЗаголовкамРазделовНаСервере("БухгалтерскаяОтчетность");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделАнализОтчетностиНажатие(Элемент)
	УстановитьСвойстваЗаголовкамРазделовНаСервере("АнализОтчетности");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделКоэффициентыНажатие(Элемент)
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Коэффициенты");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделРентабельностьНажатие(Элемент)
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Рентабельность");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРазделОценкиНажатие(Элемент)
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Оценки");
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНажатие(Элемент)
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличныйДокумент

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) <> Тип("Структура")
		ИЛИ НЕ Расшифровка.Свойство("Действие") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка.Действие = "Показать" 
		ИЛИ Расшифровка.Действие = "Свернуть" Тогда
		
		ПоказатьСкрытьОбластьДокумента(Расшифровка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "ФормированиеОтчетаФинансовыйАнализ");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если РезультатВыполнения <> Неопределено И Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		УстановитьСостояниеПолейТабличныхДокументов(ЭтотОбъект, "ФормированиеОтчета");
	Иначе
		ЗафиксироватьДлительностьКлючевойОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Если Не ОтчетГотовКПечати() Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ТабличныйДокумент = СформироватьПечатнуюФормуНаСервере();
	ВывестиТабличныйДокументНаПечать(ТабличныйДокумент);
	
КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)

	БухгалтерскийУчетКлиентПереопределяемый.Актуализировать(ЭтотОбъект, Отчет.Организация, Отчет.Период);

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)

	БухгалтерскийУчетКлиентПереопределяемый.ОтменитьАктуализацию(ЭтотОбъект, Отчет.Организация, Отчет.Период);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеФормой

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Форма.Заголовок = СтрШаблон(НСтр("ru='Финансовый анализ %1 за %2 год'"),
		БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация, Ложь),
		Формат(Отчет.Период, "ДФ=yyyy"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЗаголовкамРазделовНаСервере(ИмяТекущегоРаздела)
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы["ГруппаРезультат" + ИмяТекущегоРаздела];
	ТекущийЭлемент = Элементы["Результат" + ИмяТекущегоРаздела];
	
	Для Каждого ИмяРаздела Из МассивИменРазделов() Цикл
		ИмяДекорации = "ДекорацияРаздел" + ИмяРаздела;
		Элементы[ИмяДекорации].Гиперссылка = Истина;
		Элементы[ИмяДекорации].ЦветФона    = Новый Цвет;
	КонецЦикла;
	
	Элементы["ДекорацияРаздел" + ИмяТекущегоРаздела].Гиперссылка = Ложь;
	Элементы["ДекорацияРаздел" + ИмяТекущегоРаздела].ЦветФона = ЦветаСтиля.ДосьеТекущийРазделЦвет;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеПолейТабличныхДокументов(Форма, Состояние)

	Если Не ЗначениеЗаполнено(Форма.ИдентификаторЗадания) ИЛИ Состояние = "ФормированиеОтчета" Тогда
		Для Каждого ИмяРаздела Из МассивИменРазделов() Цикл
			ИмяТабличногоДокумента = "Результат" + ИмяРаздела;
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Форма.Элементы[ИмяТабличногоДокумента], Состояние);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Отчет.Период = Результат.КонецПериода;
		
		УстановитьВыбранныйПериод();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбранныйПериод()

	Отчет.Период = КонецМесяца(Отчет.Период);
	КонецПрошлогоМесяца = НачалоМесяца(ТекущаяДата())-1; // Дата сеанса не требуется.
	
	Если Отчет.Период > КонецПрошлогоМесяца Тогда
		Отчет.Период = КонецПрошлогоМесяца;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(НСтр("ru='Дата была изменена на %1.
			|Отчет можно сформировать только по %2.'"), Формат(КонецПрошлогоМесяца, "ДЛФ=D"), НРег(Формат(КонецПрошлогоМесяца, "ДФ=MMMM"))));
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УстановитьСостояниеПолейТабличныхДокументов(ЭтотОбъект, "НеАктуальность");

КонецПроцедуры

#КонецОбласти

#Область ПечатнаяФорма

&НаСервере
Функция СформироватьПечатнуюФормуНаСервере()

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация", Отчет.Организация);
	ПараметрыОтчета.Вставить("Период",      Отчет.Период);
	ПараметрыОтчета.Вставить("АдресХранилищаДанныеФинансовогоАнализа", АдресХранилищаДанныеФинансовогоАнализа);
	ТабличныйДокумент = Отчеты.ФинансовыйАнализ.СформироватьПечатнуюФорму(ПараметрыОтчета);
	
	Возврат ТабличныйДокумент;

КонецФункции

&НаКлиенте
Процедура ВывестиТабличныйДокументНаПечать(ТабличныйДокумент)

	ТабличныйДокумент.ТолькоПросмотр      = Истина;
	ТабличныйДокумент.АвтоМасштаб         = Истина;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	ТабличныйДокумент.ОтображатьСетку     = Ложь;
	ИдентификаторПечатнойФормы = "ПечатнаяФорма";
	НазваниеПечатнойФормы = НСтр("ru = 'Финансовый анализ'");
	
	КоллекцияПечатныхФорм               = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма                       = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета         = НазваниеПечатнойФормы;
	ПечатнаяФорма.ТабличныйДокумент     = ТабличныйДокумент;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);

КонецПроцедуры

&НаКлиенте
Функция ОтчетГотовКПечати()
	
	СостояниеОтчета = Элементы.РезультатГлавное.ОтображениеСостояния;
	
	Если СостояниеОтчета.Видимость ИЛИ РезультатГлавное.ШиринаТаблицы = 0 Тогда
		ТекстСообщения = Нстр("ru = 'Нет информации для вывода на печать.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Результат");
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ФормированиеОтчета

&НаСервере
Функция СформироватьОтчетНаСервере()

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Элементы.Актуализация.Видимость = Ложь;
	
	ИдентификаторЗадания = Неопределено;
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация", Отчет.Организация);
	ПараметрыОтчета.Вставить("Период",      Отчет.Период);
	ПараметрыОтчета.Вставить("АдресХранилищаДанныеФинансовогоАнализа", АдресХранилищаДанныеФинансовогоАнализа);
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		Новый УникальныйИдентификатор,
		"Отчеты.ФинансовыйАнализ.СформироватьОтчет",
		ПараметрыОтчета,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Формирование отчета: Финансовый анализ: %1'"),
			Отчет.Организация));
		
	АдресХранилища = РезультатВыполнения.АдресХранилища;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
		ИдентификаторЗадания = Неопределено;
	Иначе
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Возврат РезультатВыполнения;

КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	ДанныеОтчета = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	АдресХранилищаДанныеФинансовогоАнализа = ДанныеОтчета.АдресХранилищаДанныеФинансовогоАнализа;
	ОбластиРасшифровки.Очистить();
	
	Для Каждого СтрокаОбласти Из ДанныеОтчета.ОбластиРасшифровки Цикл
		НоваяСтрока = ОбластиРасшифровки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОбласти);
	КонецЦикла;
	
	Для Каждого ИмяРаздела Из МассивИменРазделов() Цикл
		ИмяТабличногоДокумента = "Результат" + ИмяРаздела;
		ТекущийРезультат = ДанныеОтчета[ИмяТабличногоДокумента];
		ТекущийРезультат.ТолькоПросмотр      = Истина;
		ТекущийРезультат.АвтоМасштаб         = Истина;
		ТекущийРезультат.ОриентацияСтраницы  = ОриентацияСтраницы.Портрет;
		ТекущийРезультат.ОтображатьЗаголовки = Ложь;
		ТекущийРезультат.ОтображатьСетку     = Ложь;
		ЭтотОбъект[ИмяТабличногоДокумента]   = ТекущийРезультат;
	КонецЦикла;
	
	Элементы.ГруппаРезультат.ТекущаяСтраница = Элементы.ГруппаРезультатГлавное;
	ТекущийЭлемент = Элементы.РезультатГлавное;
	УстановитьСвойстваЗаголовкамРазделовНаСервере("Главное");
	УстановитьСостояниеПолейТабличныхДокументов(ЭтотОбъект, "НеИспользовать");

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьОбластьДокумента(Расшифровка)
	
	Если НЕ Расшифровка.Свойство("ИмяОбласти") Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("ИмяДокумента,ИмяОбласти", Расшифровка.ИмяДокумента, Расшифровка.ИмяОбласти);
	СтрокиТаблицы = ОбластиРасшифровки.НайтиСтроки(Отбор);
	Если СтрокиТаблицы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	СтрокаОбласти = СтрокиТаблицы[0];
	
	НомерСтрокиЕще = СтрокаОбласти.ПерваяСтрока - 1;
	
	ТабличныйДокумент = ЭтотОбъект[Расшифровка.ИмяДокумента];
	Если Расшифровка.Действие = "Показать" Тогда
		ТабличныйДокумент.Область(НомерСтрокиЕще, , НомерСтрокиЕще).Видимость = Ложь;
		ТабличныйДокумент.Область(СтрокаОбласти.ПерваяСтрока, , СтрокаОбласти.ПоследняяСтрока).Видимость = Истина;
		Элементы[Расшифровка.ИмяДокумента].ТекущаяОбласть = ТабличныйДокумент.Область(СтрокаОбласти.ПоследняяСтрока, 3);
	Иначе // "Свернуть"
		ТабличныйДокумент.Область(НомерСтрокиЕще, , НомерСтрокиЕще).Видимость = Истина;
		ТабличныйДокумент.Область(СтрокаОбласти.ПерваяСтрока, , СтрокаОбласти.ПоследняяСтрока).Видимость = Ложь;
		Элементы[Расшифровка.ИмяДокумента].ТекущаяОбласть = ТабличныйДокумент.Область(НомерСтрокиЕще, 3);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивИменРазделов()
	
	МассивИменРазделов = Новый Массив;
	МассивИменРазделов.Добавить("Главное");
	МассивИменРазделов.Добавить("БухгалтерскаяОтчетность");
	МассивИменРазделов.Добавить("АнализОтчетности");
	МассивИменРазделов.Добавить("Коэффициенты");
	МассивИменРазделов.Добавить("Рентабельность");
	МассивИменРазделов.Добавить("Оценки");
	Возврат МассивИменРазделов;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьАктуальность()

	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьАктуальность(ЭтотОбъект, Отчет.Организация, Отчет.Период);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиАктуальности()

	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеПроверкиАктуальностиОтчета(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеАктуализации()

	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеАктуализацииОтчета(ЭтотОбъект, Отчет.Организация, Отчет.Период);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеАктуализации()

	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьЗавершениеАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.Период);

КонецПроцедуры

#КонецОбласти

#Область ФоновоеЗадание

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ЗафиксироватьДлительностьКлючевойОперации()
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Неопределено;
		ЗагрузитьПодготовленныеДанные();
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал,
			Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти