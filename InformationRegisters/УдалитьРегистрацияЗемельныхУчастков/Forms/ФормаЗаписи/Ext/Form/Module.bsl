﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		
		Запись.Период = ТекущаяДатаСеанса();
		
		Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.Регистрация Тогда
			Запись.ВключатьВНалоговуюБазу = Истина;
		Иначе
			Запись.ВключатьВНалоговуюБазу = Ложь;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.ОсновноеСредство) Тогда
			ЗаполнитьПараметрыПоОсновномуСредству();
		КонецЕсли;
		
		НастроитьФормуПоОбъекту();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Запись, ВыбранноеЗначение);
		УстановитьТекстНалоговойЛьготы(ЭтаФорма);
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьФормуПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Параметры.Ключ.Организация <> ТекущийОбъект.Организация
		ИЛИ Параметры.Ключ.ОсновноеСредство <> ТекущийОбъект.ОсновноеСредство
		ИЛИ Параметры.Ключ.Период <> ТекущийОбъект.Период Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Период",           ТекущийОбъект.Период);
		Запрос.УстановитьПараметр("Организация",      ТекущийОбъект.Организация);
		Запрос.УстановитьПараметр("ОсновноеСредство", ТекущийОбъект.ОсновноеСредство);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(РегистрацияЗемельныхУчастков.ВидЗаписи) КАК ВидЗаписи
		|ИЗ
		|	РегистрСведений.УдалитьРегистрацияЗемельныхУчастков КАК РегистрацияЗемельныхУчастков
		|ГДЕ
		|	РегистрацияЗемельныхУчастков.Период = &Период
		|	И РегистрацияЗемельныхУчастков.Организация = &Организация
		|	И РегистрацияЗемельныхУчастков.ОсновноеСредство = &ОсновноеСредство";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() > 0 Тогда
			
			Выборка.Следующий();
			
			ШаблонСообщения = НСтр("ru = '%1 по основному средству <%2> 
			|уже есть запись <%3> в организации <%4>!'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
				Формат(ТекущийОбъект.Период, "ДФ=dd.MM.yyyy"), ТекущийОбъект.ОсновноеСредство, ТекущийОбъект.ВидЗаписи,
				ТекущийОбъект.Организация);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО Тогда
			ТекущийОбъект.КодПоОКТМО = КодПоОКТМОПоМестуНахожденияОрганизации;
			ТекущийОбъект.КодПоОКАТО = КодПоОКАТОПоМестуНахожденияОрганизации;
			ТекущийОбъект.НалоговыйОрган = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
		ИначеЕсли Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
			ТекущийОбъект.КодПоОКТМО = КодПоОКТМОВДругомНалоговомОргане;
			ТекущийОбъект.КодПоОКАТО = КодПоОКАТОВДругомНалоговомОргане;
		Иначе
			ТекущийОбъект.НалоговыйОрган = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
		КонецЕсли;
		
		Если Год(ТекущийОбъект.Период) >= 2014 Тогда
			ТекущийОбъект.КодПоОКАТО = "";
		КонецЕсли;
		
		Если НЕ Запись.ОбщаяСобственность Тогда
			ТекущийОбъект.ДоляВПравеОбщейСобственностиЧислитель   = 0;
			ТекущийОбъект.ДоляВПравеОбщейСобственностиЗнаменатель = 0;
		КонецЕсли;
		
		Если НЕ Запись.ЖилищноеСтроительство Тогда
			ТекущийОбъект.ДатаНачалаПроектирования                = '00010101';
			ТекущийОбъект.ДатаРегистрацииПравНаОбъектНедвижимости = '00010101';
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Запись.ОбщаяСобственность Тогда
		
		Если НЕ ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЧислитель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Доля в праве общей собственности числитель'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.ДоляВПравеОбщейСобственностиЧислитель", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЗнаменатель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Доля в праве общей собственности знаменатель'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.ДоляВПравеОбщейСобственностиЗнаменатель", , Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЧислитель)
			И ЗначениеЗаполнено(Запись.ДоляВПравеОбщейСобственностиЗнаменатель)
			И Запись.ДоляВПравеОбщейСобственностиЧислитель > Запись.ДоляВПравеОбщейСобственностиЗнаменатель Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "КОРРЕКТНОСТЬ", НСтр("ru = 'Доля в праве общей собственности числитель'"), , ,
				НСтр("ru = 'Доля в праве на участок: числитель дроби больше знаменателя!'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.ДоляВПравеОбщейСобственностиЧислитель", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
		
	Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.Регистрация
		И Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО Тогда
		
		Если ПустаяСтрока(КодПоОКТМОПоМестуНахожденияОрганизации) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКТМО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКТМОПоМестуНахожденияОрганизации", , Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(КодПоОКАТОПоМестуНахожденияОрганизации) И Год(Запись.Период) < 2014 Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКАТО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКАТОПоМестуНахожденияОрганизации", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.Регистрация
		И Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		
		Если НЕ ЗначениеЗаполнено(Запись.НалоговыйОрган) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Налоговый орган'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.НалоговыйОрган", , Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(КодПоОКТМОВДругомНалоговомОргане) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКТМО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКТМОВДругомНалоговомОргане", , Отказ);
		КонецЕсли;
		
		Если ПустаяСтрока(КодПоОКАТОВДругомНалоговомОргане) И Год(Запись.Период) < 2014 Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Код по ОКАТО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодПоОКАТОВДругомНалоговомОргане", , Отказ);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПериодПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ОсновноеСредство)
		И ЗначениеЗаполнено(Запись.Организация) Тогда
		
		ЗаполнитьПараметрыПоОсновномуСредству();
		
	КонецЕсли;
	
	УстановитьГоловнуюОрганизацию(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеСредствоПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ОсновноеСредство)
		И ЗначениеЗаполнено(Запись.Организация) Тогда
		
		ЗаполнитьПараметрыПоОсновномуСредству();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодКатегорииЗемельНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыборКода("КодКатегорииЗемель", "КатегорииЗемельныхУчастков");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщаяСобственностьПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖилищноеСтроительствоПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПостановкаНаУчетВНалоговомОрганеПриИзменении(Элемент)
	
	УстановитьДоступностьНалоговогоОргана(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйОрганПриИзменении(Элемент)
	НалоговыйОрганПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КБКНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыборКода("КБК", "КБК");
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстНалоговойЛьготыНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ПараметрыЛьготы = Новый Структура(
		"НалоговаяСтавка,
		|ВариантУменьшенияСуммыНалога,
		|ЛьготнаяСтавка,
		|ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
		|ДоляНеОблагаемойНалогомПлощадиЧислитель,
		|КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
		|КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
		|НалоговаяЛьготаПоНалоговойБазе,
		|НеОблагаемаяНалогомСумма,
		|ПроцентУменьшенияСуммыНалога,
		|СнижениеНалоговойСтавки,
		|СниженнаяНалоговаяСтавка,
		|СуммаУменьшенияСуммыНалога,
		|УменьшениеНалоговойБазыНаСумму,
		|УменьшениеНалоговойБазыПоСтатье391,
		|Период");
	ЗаполнитьЗначенияСвойств(ПараметрыЛьготы, Запись);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыЛьготы);
	ПараметрыФормы.Вставить("ТолькоПросмотр"    , ТолькоПросмотр);
	
	ОткрытьФорму("РегистрСведений.УдалитьРегистрацияЗемельныхУчастков.Форма.ФормаНастройкиЛьготы", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПараметрыПоОсновномуСредству()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", Запись.ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация",      Запись.Организация);
	Запрос.УстановитьПараметр("Период",           Запись.Период);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодКатегорииЗемель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КадастровыйНомер,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КадастроваяСтоимость,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ОбщаяСобственность,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляВПравеОбщейСобственностиЧислитель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляВПравеОбщейСобственностиЗнаменатель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ЖилищноеСтроительство,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДатаНачалаПроектирования,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДатаРегистрацииПравНаОбъектНедвижимости,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ПостановкаНаУчетВНалоговомОргане,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговыйОрган,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодПоОКАТО,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговаяСтавка,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговаяЛьготаПоНалоговойБазе,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	РегистрацияЗемельныхУчастковСрезПоследних.УменьшениеНалоговойБазыПоСтатье391,
	|	РегистрацияЗемельныхУчастковСрезПоследних.УменьшениеНалоговойБазыНаСумму,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НеОблагаемаяНалогомСумма,
	|	РегистрацияЗемельныхУчастковСрезПоследних.СниженнаяНалоговаяСтавка,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ПроцентУменьшенияСуммыНалога,
	|	РегистрацияЗемельныхУчастковСрезПоследних.СуммаУменьшенияСуммыНалога
	|ИЗ
	|	РегистрСведений.УдалитьРегистрацияЗемельныхУчастков.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК РегистрацияЗемельныхУчастковСрезПоследних";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		
		НастроитьФормуПоОбъекту();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоОбъекту()
	
	ВыполнитьИнициализацию();
	
	УстановитьВидимость();
	УстановитьДоступностьНалоговогоОргана(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	УстановитьТекстНалоговойЛьготы(ЭтаФорма);
	УстановитьГоловнуюОрганизацию(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьИнициализацию()
	
	Если ИнициализацияВыполнена Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализацияВыполнена = Истина;
	
	ПостановкаНаУчетВНалоговомОргане = УправлениеВнеоборотнымиАктивами.ПолучитьСтруктуруСоЗначениямиПеречисления("ПостановкаНаУчетВНалоговомОргане");

	Если Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО Тогда
		КодПоОКТМОПоМестуНахожденияОрганизации = Запись.КодПоОКТМО;
		КодПоОКАТОПоМестуНахожденияОрганизации = Запись.КодПоОКАТО;
	ИначеЕсли Запись.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		КодПоОКТМОВДругомНалоговомОргане = Запись.КодПоОКТМО;
		КодПоОКАТОВДругомНалоговомОргане = Запись.КодПоОКАТО;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.Регистрация Тогда
		Элементы.ГруппаСтраницыПараметрыРегистрации.Видимость = Истина;
	Иначе
		Элементы.ГруппаСтраницыПараметрыРегистрации.Видимость = Ложь;
	КонецЕсли;
	
	ПоказыватьКодПоОКАТО = Год(Запись.Период) < 2014;
	Элементы.КодПоОКАТОПоМестуНахожденияОрганизации.Видимость = ПоказыватьКодПоОКАТО;
	Элементы.КодПоОКАТОВДругомНалоговомОргане.Видимость = ПоказыватьКодПоОКАТО;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьНалоговогоОргана(Форма)
	
	Элементы = Форма.Элементы;
	
	ПостановкаНаУчетСДругимКодомПоОКАТО = (Форма.Запись.ПостановкаНаУчетВНалоговомОргане = Форма.ПостановкаНаУчетВНалоговомОргане.СДругимКодомПоОКАТО);
	Элементы.КодПоОКТМОПоМестуНахожденияОрганизации.Доступность = ПостановкаНаУчетСДругимКодомПоОКАТО;
	Элементы.КодПоОКАТОПоМестуНахожденияОрганизации.Доступность = ПостановкаНаУчетСДругимКодомПоОКАТО;
	
	ПостановкаНаУчетВДругомНалоговомОргане = (Форма.Запись.ПостановкаНаУчетВНалоговомОргане = Форма.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане);
	Элементы.НалоговыйОрган.Доступность                   = ПостановкаНаУчетВДругомНалоговомОргане;
	Элементы.КодПоОКТМОВДругомНалоговомОргане.Доступность = ПостановкаНаУчетВДругомНалоговомОргане;
	Элементы.КодПоОКАТОВДругомНалоговомОргане.Доступность = ПостановкаНаУчетВДругомНалоговомОргане;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ДоляВПравеОбщейСобственностиЧислитель.Доступность   = Форма.Запись.ОбщаяСобственность;
	Элементы.ДоляВПравеОбщейСобственностиЗнаменатель.Доступность = Форма.Запись.ОбщаяСобственность;
	
	Элементы.ДатаНачалаПроектирования.Доступность                = Форма.Запись.ЖилищноеСтроительство И Год(Форма.Запись.Период)<2008;
	Элементы.ДатаРегистрацииПравНаОбъектНедвижимости.Доступность = Форма.Запись.ЖилищноеСтроительство;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстНалоговойЛьготы(Форма)
	
	ТекстНалоговойЛьготы = "";
	
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.ОсвобождениеОтНалогообложенияПоСтатье395") Тогда
		
		ТекстНалоговойЛьготы = НСтр("ru = 'Освобождение от налогообложения по ст. 395 НК РФ'");
		
		Если НЕ ПустаяСтрока(Форма.Запись.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395) Тогда
			ШаблонТекста = НСтр("ru = '( %1 )'");
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.УменьшениеНалоговойБазы") Тогда
		
		Если Форма.Запись.УменьшениеНалоговойБазыПоСтатье391 Тогда
		
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
				+ НСтр("ru = 'Не облагаемая налогом сумма 10 000 руб., установленная ст. 391 НК РФ'");
			
			Если НЕ ПустаяСтрока(Форма.Запись.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391) Тогда
				ШаблонТекста = НСтр("ru = '( %1 )'");
				ТекстНалоговойЛьготы = ТекстНалоговойЛьготы
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Форма.Запись.УменьшениеНалоговойБазыНаСумму Тогда
			ШаблонТекста = НСтр("ru = 'Не облагаемая налогом сумма %1 руб., установленная местным нормативным актом'");
			ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.НеОблагаемаяНалогомСумма);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.ОсвобождениеОтНалогообложенияМестное") Тогда
		
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ НСтр("ru = 'Освобождение от налогообложения, установленное местным нормативным актом'");
		
	КонецЕсли;
		
		
	Если Форма.Запись.НалоговаяЛьготаПоНалоговойБазе
			= ПредопределенноеЗначение("Перечисление.ВидНалоговойЛьготыПоНалоговойБазеПоЗемельномуНалогу.НеОблагаемаяНалогомПлощадь") Тогда
		
		ШаблонТекста = НСтр("ru = 'Доля не облагаемой налогом площади %1 / %2'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста,
				Форма.Запись.ДоляНеОблагаемойНалогомПлощадиЧислитель, Форма.Запись.ДоляНеОблагаемойНалогомПлощадиЗнаменатель);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Запись.ПроцентУменьшенияСуммыНалога) Тогда
		
		ШаблонТекста = НСтр("ru = 'Уменьшение суммы налога на %1 %2'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.ПроцентУменьшенияСуммыНалога, "%");
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Форма.Запись.СуммаУменьшенияСуммыНалога) Тогда
		
		ШаблонТекста = НСтр("ru = 'Уменьшение суммы налога в размере %1 руб.'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.СуммаУменьшенияСуммыНалога);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Запись.СниженнаяНалоговаяСтавка) Тогда
		
		ШаблонТекста = НСтр("ru = 'Снижение налоговой ставки до %1 %2'");
		ТекстНалоговойЛьготы = ТекстНалоговойЛьготы + ?(ПустаяСтрока(ТекстНалоговойЛьготы), "", "; ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, Форма.Запись.СниженнаяНалоговаяСтавка, "%");
		
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстНалоговойЛьготы) Тогда
		ТекстНалоговойЛьготы = НСтр("ru = 'Не применяется'");
	КонецЕсли;
	
	Форма.ТекстНалоговойЛьготы = ТекстНалоговойЛьготы;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьГоловнуюОрганизацию(Форма)
	
	Форма.ГоловнаяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Форма.Запись.Организация);
		
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.ОсновноеСредство)
		И ЗначениеЗаполнено(Запись.Организация) Тогда
		
		ЗаполнитьПараметрыПоОсновномуСредству();
		
	КонецЕсли;
	
	УстановитьВидимость();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыборКода(ИмяКода, НазваниеМакета)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта",		"РегистрСведений");
	ПараметрыФормы.Вставить("НазваниеОбъекта",	"РегистрацияЗемельныхУчастков");
	ПараметрыФормы.Вставить("НазваниеМакета",	НазваниеМакета);
	ПараметрыФормы.Вставить("ТекущийПериод",	Запись.Период);
	ПараметрыФормы.Вставить("ТекущийКод",		Запись[ИмяКода]);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяКода", ИмяКода);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборКодаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораКода", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ИмяКода = ДополнительныеПараметры.ИмяКода;	
	
	ВыбранныйКод = РезультатЗакрытия;	
	
	Если ВыбранныйКод <> Неопределено Тогда
		
		Модифицированность = Истина;
		
		Запись[ИмяКода] = ВыбранныйКод;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НалоговыйОрганПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(Запись.НалоговыйОрган) Тогда 
		КодПоОКТМОВДругомНалоговомОргане = Запись.НалоговыйОрган.КодПоОКТМО;
		КодПоОКАТОВДругомНалоговомОргане = Запись.НалоговыйОрган.КодПоОКАТО;
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти
